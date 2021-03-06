--[[
This module provides branching:
if then else
switch case
]]

rule([[ IfStatement <- IfPart (ElseIfPart)* ElsePart? ~EndIfKeyword ]], basic.concat )
rule([[ IfPart <- ~IfKeyword _ Expression _ SilentTerminal IfBody ]], "if( {1}{2}{3} ){4}{\n{5}\n}\n" )
rule([[ IfKeyword <- 'if' ]])
table.insert(keywords, "IfKeyword")
-- since the syntax error part of local statement swallows everything, other possible branches have to be excluded
rule([[ IfBody <- Skip (!ElseIfKeyword !ElseKeyword !EndIfKeyword LocalStatement Skip)* ]], basic.concat )
rule([[ ElseIfPart <- ~ElseIfKeyword _ Expression _ SilentTerminal IfBody ]], "else if( {1}{2}{3} ){4}{\n{5}\n}\n" )
rule([[ ElseIfKeyword <- 'elseif' ]])
table.insert(keywords, "ElseIfKeyword")
rule([[ ElsePart <- ~ElseKeyword _ SilentTerminal IfBody ]], "else {1}{2}{\n{3}\n}\n" )
rule([[ ElseKeyword <- 'else' ]])
table.insert(keywords, "ElseKeyword")
rule([[ EndIfKeyword <- 'end' ]])
table.insert(keywords, "EndIfKeyword")

table.insert(localStatements, "IfStatement")


rule([[ SwitchStatement <- SwitchPart Skip CaseList ~EndSwitchKeyword ]], "{1}{2}{\n{3}\n}" )
rule([[ SwitchPart <- ~SwitchKeyword _ Expression _ SilentTerminal ]], "switch( {1}{2}{3} ){4}" )
rule([[ SwitchKeyword <- 'switch' ]])
table.insert(keywords, "SwitchKeyword")
rule([[ CaseList <- Skip (Case Skip)* ]], basic.concat )
rule([[ Case <- (CaseConditionList / DefaultKeyword) _ SilentTerminal CaseBody Skip ]], basic.concat )
rule([[ CaseConditionList <- ~CaseKeyword _ CaseCondition (_ ',' _ CaseCondition)* ]], basic.concat )
rule([[ CaseCondition <- Expression / DefaultKeyword ]],
	function(arg)
		if arg.choice == 1 then
			return {"case(" .. arg.values[1][1] .. "): "}
		else
			return {arg.values[1][1]}
		end
	end
)
rule([[ CaseKeyword <- 'case' ]])
table.insert(keywords, "CaseKeyword")
rule([[ FallKeyword <- 'fall' ]])
table.insert(keywords, "FallKeyword")
rule([[ OptionalFallStatement <- (FallKeyword _ SilentTerminal)? ]],
	function(arg)
		if #arg.values > 0 then -- fall is present, don't return "break;", just possible comments
			return {arg.values[2][1] .. arg.values[3][1]}
		else
			return {"break;\n"} -- no fall -> break
		end
	end
)
rule([[ DefaultKeyword <- 'default' ]], "default: " )
table.insert(keywords, "DefaultKeyword")
rule([[ EndSwitchKeyword <- 'end' ]])
table.insert(keywords, "EndSwitchKeyword")
-- since the syntax error part of local statement swallows everything, other possible branches have to be excluded
rule([[ CaseBody <- Skip (!CaseKeyword !DefaultKeyword !FallKeyword !EndSwitchKeyword LocalStatement Skip)* OptionalFallStatement Skip ]], basic.concat )

table.insert(localStatements, "SwitchStatement")
