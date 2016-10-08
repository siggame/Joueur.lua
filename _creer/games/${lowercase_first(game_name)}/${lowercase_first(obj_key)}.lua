-- This is a simple class to represent the ${obj_key} object in the game. You can extend it by adding utility functions here in this file.
<%include file="functions.noCreer" /><%
parent_classes = obj['parentClasses'] %>
local class = require("joueur.utilities.class")
% if len(parent_classes) > 0:
% for parent_class in parent_classes:
local ${parent_class} = require("games.${lowercase_first(game_name)}.${lowercase_first(parent_class)}")
% endfor
% else:
<% if obj_key == "Game":
    parent_classes = [ 'BaseGame' ]
else:
    parent_classes = [ 'BaseGameObject' ]
%>local ${parent_classes[0]} = require("joueur.${lowercase_first(parent_classes[0])}")
% endif
<%
seperator = "_SEP"
do_inherited = False
%>
${merge("-- ", "requires", "-- you can add addtional require(s) here")}

--- ${shared['lua']['format_description'](obj['description'])}
-- @classmod ${obj_key}
local ${obj_key} = class(${", ".join(parent_classes)})

-- initializes a ${obj_key} with basic logic as provided by the Creer code generator
function ${obj_key}:init(...)
% for parent_class in reversed(parent_classes):
    ${parent_class}.init(self, ...)
% endfor

% if obj_key == "Game":
    --- The name of this game, "{game_name}".
    -- @field[string] self.name
% endif
    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

% for attr_name in obj['attribute_names']:
<% attr_parms = obj['attributes'][attr_name]
%>    --- ${shared['lua']['format_description'](attr_parms['description'])}
    self.${attr_name} = ${shared['lua']['default'](attr_parms["type"], attr_parms["default"] if 'default' in attr_parms else None)}
% endfor

% for attr_name in obj['inheritedAttribute_names']:
<% attr_parms = obj['inheritedAttributes'][attr_name]
%>    --- (inherited) ${shared['lua']['format_description'](attr_parms['description'])}
    -- @field[${shared['lua']['type'](attr_parms['type'])}] self.${attr_name}
    -- @see ${attr_parms['inheritedFrom']}.${attr_name}

% endfor

% if obj_key == "Game":

    self.name = "${game_name}"

    self._gameObjectClasses = {
% for game_obj_key in game_obj_names:
        ${game_obj_key} = require("games.${lowercase_first(game_name)}.${lowercase_first(game_obj_key)}"),
% endfor
    }
% endif
end

% for function_name in obj['function_names'] + [seperator] + obj['inheritedFunction_names']:
<%
if function_name == seperator:
    do_inherited = True
    continue

function_parms = obj['functions' if not do_inherited else 'inheritedFunctions'][function_name]
%>--- ${'(inherited) ' if do_inherited else ''}${shared['lua']['format_description'](function_parms['description'])}
% if do_inherited:
-- @function ${obj_key}:${function_name}
-- @see ${function_parms['inheritedFrom']}:${function_name}
% endif
% if 'arguments' in function_parms:
% for arg_parms in function_parms['arguments']:
-- @tparam${"" if not arg_parms['optional'] else ("[opt=" + shared['lua']['value'](arg_parms['type'], arg_parms['default']) + "]")} ${shared['lua']['type'](arg_parms['type'])} ${arg_parms['name']} ${shared['lua']['format_description'](arg_parms['description'])}
% endfor
% endif
% if function_parms['returns'] != None:
-- @treturn ${shared['lua']['type'](function_parms['returns']['type'])} ${shared['lua']['format_description'](function_parms['returns']['description'])}
% endif
%if not do_inherited:
function ${obj_key}:${function_name}(${", ".join(function_parms['argument_names'])})
% if 'arguments' in function_parms:
% for arg_parms in function_parms['arguments']:
% if arg_parms['optional']:
    if ${arg_parms['name']} == nil then
        ${arg_parms['name']} = ${shared['lua']['value'](arg_parms['type'], arg_parms['default'])}
    end

% endif
% endfor
% endif
    return ${shared['lua']['cast'](function_parms['returns']['type']) if function_parms['returns'] != None else ""}(self:_runOnServer("${function_name}", {
% for argument_name in function_parms['argument_names']:
        ${argument_name} = ${argument_name},
% endfor
    }))
end
% endif

% endfor

${merge("-- ", "functions", "-- if you want to add any client side logic (such as state checking functions) this is where you can add them")}

return ${obj_key}
