import Foundation

extension NSData {
    func toString (encoding:UInt) -> String {
        return NSString(data: self as Data, encoding: encoding)! as String;
    }
}

class BinaryReader {
    var data:NSData;
    
    var bufferPosition: Int = 0;
    
    init (data: NSData) {
        self.data = data;
    }
    
    func readSlice (length: Int) -> NSData {
        let slice = self.data.subdata(with: NSMakeRange(bufferPosition, length));
        bufferPosition += length;
        return slice as NSData;
    }
    
    func readDoubleBE () -> Int64 {
        let data = readDoubleBE(offset: bufferPosition);
        bufferPosition += 8;
        return data;
    }
    
    func readDoubleBE (offset: Int) -> Int64 {
        let data = slice(loc: offset, len: 8);
        var out: double_t = 0;
        memcpy(&out, data.bytes, MemoryLayout<double_t>.size);
        return Int64(NSSwapHostDoubleToBig(Double(out)).v);
    }
    
    func readIntBE () -> UInt32 {
        let data = readIntBE(offset: bufferPosition);
        bufferPosition += 4;
        return data;
    }
    
    func readIntBE (offset: Int) -> UInt32 {
        let data = slice(loc: offset, len: 4);
        var out:NSInteger = 0;
        data.getBytes(&out, length: MemoryLayout<NSInteger>.size);
        return CFSwapInt32HostToBig(UInt32(out));
    }
    
    func readDoubleLE () -> Int64 {
        let data = readDoubleLE(offset: bufferPosition);
        bufferPosition += 8;
        return data;
    }
    
    func readDoubleLE (offset: Int) -> Int64 {
        let data = slice(loc: offset, len: 8);
        var out:double_t = 0;
        memcpy(&out, data.bytes, MemoryLayout<double_t>.size);
        return Int64(out);
    }
    
    func readIntLE () -> UInt32 {
        let data = readIntLE(offset: bufferPosition)
        bufferPosition += 4
        return data
    }
    
    func readIntLE (offset: Int) -> UInt32 {
        let data = slice(loc: offset, len: 4)
        var out:NSInteger = 0;
        data.getBytes(&out, length: MemoryLayout<NSInteger>.size)
        return UInt32(out);
    }
    
    func slice (loc: Int, len: Int) -> NSData {
        return self.data.subdata(with: NSMakeRange(loc, len)) as NSData
    }
}

enum BinaryCookiesError: Error {
    case BadFileHeader
    case InvalidEndOfCookieData
    case UnexpectedCookieHeaderValue
}

struct Cookie {
    var expiration: Int64;
    var creation: Int64;
    var domain: String;
    var name: String;
    var path: String;
    var value: String;
    var secure: Bool = false;
    var http: Bool = false;
}

class CookieParser {
    var numPages: UInt32 = 0;
    var pageSizes: [UInt32] = [];
    var pageNumCookies: [UInt32] = [];
    var pageCookieOffsets: [[UInt32]] = [];
    var pages: [BinaryReader] = [];
    var cookieData: [[BinaryReader]] = [];
    var cookies: [Cookie] = [];
    
    var reader:BinaryReader?;
    
    func processCookieData (data: NSData) throws -> [Cookie] {
        
        reader = BinaryReader(data: data);
        
        let header = reader!.readSlice(length: 4).toString(encoding: String.Encoding.utf8.rawValue);
        
        if (header == "cook") {
            getNumPages();
            getPageSizes();
            getPages();
            
            for (index, _) in pages.enumerated() {
                try getNumCookies(index: index);
                getCookieOffsets(index: index);
                getCookieData(index: index);
                
                for (cookieIndex, _) in cookieData[index].enumerated() {
                    try parseCookieData(cookie: cookieData[index][cookieIndex]);
                }
            }
        } else {
            throw BinaryCookiesError.BadFileHeader;
        }
        
        return cookies;
    }
    
    func parseCookieData (cookie: BinaryReader) throws {
        let macEpochOffset: Int64 = 978307199;
        var offsets: [UInt32] = [UInt32]();
        
        _ = cookie.readIntLE(offset: 0); // unknown1, not used
        _ = cookie.readIntLE(offset: 4); // unknown2, not used
        let flags = cookie.readIntLE(offset: 4 + 4); // flags
        _ = cookie.readIntLE(offset: 8 + 4); // unknown3, not used
        offsets.append(cookie.readIntLE(offset: 12 + 4)); // domain
        offsets.append(cookie.readIntLE(offset: 16 + 4)); // name
        offsets.append(cookie.readIntLE(offset: 20 + 4)); // path
        offsets.append(cookie.readIntLE(offset: 24 + 4)); // value
        
        let endOfCookie = cookie.readIntLE(offset: 28 + 4);
        
        if (endOfCookie != 0) {
            throw BinaryCookiesError.InvalidEndOfCookieData;
        }
        
        let expiration = (cookie.readDoubleLE(offset: 32 + 8) + macEpochOffset) * 1000;
        let creation = (cookie.readDoubleLE(offset: 40 + 8) + macEpochOffset) * 1000;
        var domain: String = "";
        var name: String = "";
        var path: String = "";
        var value: String = "";
        var secure: Bool = false;
        var http: Bool = false;
        
        let nsCookieString = cookie.data.toString(encoding: String.Encoding.ascii.rawValue) as NSString;
        
        for (index, offset) in offsets.enumerated() {
            
            let endOffset = nsCookieString.range(of: "\u{0000}", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(Int(offset), nsCookieString.length - Int(offset))).location
            
            let string = nsCookieString.substring(with: NSMakeRange(Int(offset), Int(endOffset)-Int(offset)));
            
            if (index == 0) {
                domain = string;
            } else if (index == 1) {
                name = string;
            } else if (index == 2) {
                path = string;
            } else if (index == 3) {
                value = string;
            }
        }
        
        if (flags == 1) {
            secure = true;
        } else if (flags == 4) {
            http = true;
        } else if (flags == 5) {
            secure = true;
            http = true;
        }
        
        cookies.append(Cookie(expiration: expiration,
                              creation: creation,
                              domain: domain,
                              name: name,
                              path: path,
                              value: value,
                              secure: secure,
                              http: http));
    }
    
    func getNumPages () {
        numPages = reader!.readIntBE();
    }
    
    func getCookieOffsets (index:Int) {
        let page = pages[index];
        var offsets:[UInt32] = [UInt32]();
        
        let numCookies = pageNumCookies[index];
        
        for _ in 0 ..< Int(numCookies) {
            offsets.append(page.readIntLE());
        }
        
        pageCookieOffsets.append(offsets);
    }
    
    func getNumCookies (index:Int) throws {
        let page = pages[index];
        
        let header = page.readIntBE();
        
        if (header != 256) {
            throw BinaryCookiesError.UnexpectedCookieHeaderValue;
        }
        
        pageNumCookies.append(page.readIntLE());
    }
    
    func getCookieData (index:Int) {
        let page = pages[index];
        
        let cookieOffsets = pageCookieOffsets[index];
        
        var pageCookies:[BinaryReader] = [BinaryReader]();
        
        for (_, cookieOffset) in cookieOffsets.enumerated() {
            let cookieSize = page.readIntLE(offset: Int(cookieOffset));
            
            pageCookies.append(BinaryReader(data: page.slice(loc: Int(cookieOffset), len: Int(cookieSize))));
        }
        
        cookieData.append(pageCookies);
    }
    
    func getPageSizes () {
        for _ in 0 ..< Int(numPages) {
            pageSizes.append(reader!.readIntBE());
        }
    }
    
    func getPages () {
        for (_, pageSize) in pageSizes.enumerated() {
            pages.append(BinaryReader(data: reader!.readSlice(length: Int(pageSize))));
        }
    }
}

public class BinaryCookies {
    
    static func parse (cookiePath: String, callback:(BinaryCookiesError?, [Cookie]?) -> ()) {
        
        let parser = CookieParser()
        let data:NSData! = NSData(contentsOf: NSURL(fileURLWithPath: cookiePath) as URL);
        
        do {
            callback(nil, try parser.processCookieData(data: data));
        } catch {
            callback(error as? BinaryCookiesError, nil);
        }
    }
    
    static func parse (cookieURL: NSURL, callback:@escaping (BinaryCookiesError?, [Cookie]?) -> ()) {
        
        let parser = CookieParser();
        
        DispatchQueue.global(qos: .default).async(execute: {
            let data:NSData! = NSData(contentsOf: cookieURL as URL);
            
            do {
                callback(nil, try parser.processCookieData(data: data));
            } catch {
                callback(error as? BinaryCookiesError, nil);
            }
        })
    }
    
    class func parse (data: NSData, callback:@escaping (BinaryCookiesError?, [Cookie]?) -> ()) {
        
        let parser = CookieParser();
        
        DispatchQueue.global(qos: .default).async(execute: {
            do {
                callback(nil, try parser.processCookieData(data: data));
            } catch {
                callback(error as? BinaryCookiesError, nil);
            }
        })
    }
}
