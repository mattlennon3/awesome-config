
---
-- Function to retrieve console output
-- https://gist.github.com/dukeofgaming/453cf950abd99c3dc8fc
--
-- cmd: string
-- raw: boolean (return raw output if true)
-- TODO: DELETE OR REPLACE WITH ASYNC
function os.capture(cmd, raw)
    local handle = assert(io.popen(cmd, 'r'))
    local output = assert(handle:read('*a'))
    
    handle:close()
    
    if raw then 
        return output 
    end
   
    output = string.gsub(
        string.gsub(
            string.gsub(output, '^%s+', ''), 
            '%s+$', 
            ''
        ), 
        '[\n\r]+',
        ' '
    )

   return output
end