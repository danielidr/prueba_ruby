require "uri"
require "net/http"
require "openssl"
require "json"

def request(address,key)
    url = URI(address + key)
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    response = http.request(request)
    return JSON.parse(response.read_body)
end

data = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=","eFjc1f8ZXr99SmWSQPkzyveyWWFpDDsPYx7WsmUt")


def buid_web_page(hash)
    data_access = hash["photos"]
    images = data_access.map {|x| x["img_src"]}
    list = ""
    images.each do |img|
      list += "\t<li><img src=#{img}></li>\n"
    end
    page = "<html>\n<head>\n</head>\n<body>\n<ul>\n" + list + "</ul>\n</body>\n</html>"
    File.write('index.html',page)
end

buid_web_page(data)

def photos_count(hash)
    data_access = hash["photos"]
    cam_arreglo = data_access.map {|x| x["camera"]}
    hash_result = {}
    
    cam_arreglo.each do |cam|
      cam_name = cam["name"]
      if hash_result.include?(cam_name) 
        count_cam = hash_result[cam_name]
        count_cam += 1
        hash_result[cam_name] = count_cam
      else
        hash_result[cam_name]=1
      end
    end
    hash_result
end

photos_count(data)