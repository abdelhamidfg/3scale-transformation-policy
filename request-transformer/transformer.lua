local policy = require('apicast.policy')
local _M = policy.new('transformer', '1.0.0')

local new = _M.new
--request-transformer policy
function _M.new(config)
   local self = new(config)
   self.rules = {}
   for _, rule in ipairs(config.rules) do
    table.insert( self.rules, {
     param_name=rule.param_name,
     header_name=rule.header_name
    })    
   end 
    return self
end

local function isempty(s)
    return s == nil or s == ''
end

function tableContains(table, element)
     for index, value in pairs(table) do
        if string.lower(index) == string.lower(element) then
            return true
        end
    end
    return false
end

--request header
-- change the request before it reaches upstream
--transform query parameter as a header parameter in the request or response
function _M:rewrite()
    local querystring = ngx.req.get_uri_args()
    for _, rule in ipairs(self.rules) do 
     if tableContains(querystring, rule.param_name) then
        ngx.log(ngx.DEBUG, "query string has been found",rule.param_name)
        ngx.req.set_header(rule.header_name,querystring[rule.param_name])
    else  
        ngx.log(ngx.DEBUG, "query string hasnot been not found",rule.param_name)
  
   end
end

  end


  

return _M