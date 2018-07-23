
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function table1()
	print("called table1()")
	return {label="table1", a=1, b=2}
end

function table2()
	print("called table2()")
	return {label="table2", c=3, d=4, subtable={e=5}}
end

function usetables(t1, t2)
	print("printing tables:")
	print(dump(t1))
	print(dump(t2))
end