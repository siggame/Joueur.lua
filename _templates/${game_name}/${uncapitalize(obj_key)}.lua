-- ${header}
-- This is a simple class to represent the ${obj_key} object in the game. You can extend it by adding utility functions here in this file.
<%include file="functions.noCreer" /><%
parent_classes = obj['parentClasses'] %>
local class = require("utilities.class")
% if len(parent_classes) > 0:
% for parent_class in parent_classes:
local ${parent_class} = require("${game_name}.${uncapitalize(parent_class)}")
% endfor
% else:
<% if obj_key == "Game":
    parent_classes = [ 'BaseGame' ]
else:
    parent_classes = [ 'BaseGameObject' ]
%>local ${parent_classes[0]} = require("${uncapitalize(parent_classes[0])}")
% endif

${merge("-- ", "requires", "-- you can add addtional require(s) here")}

--- @class ${obj_key}: ${obj['description']}
local ${obj_key} = class(${", ".join(parent_classes)})

--- initializes a ${obj_key} with basic logic as provided by the Creer code generator
function ${obj_key}:init(...)
% for parent_class in reversed(parent_classes):
    ${parent_class}.init(self, ...)
% endfor

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

% for attr_name, attr_parms in obj['attributes'].items():
    -- ${attr_parms['description']}
    self.${attr_name} = ${shared['lua']['default'](attr_parms["type"], attr_parms["default"] if 'default' in attr_parms else None)}
% endfor
% if obj_key == "Game":

    self.name = "${game_name}"

    self._gameObjectClasses = {
% for game_obj_key, game_obj in game_objs.items():
        ${game_obj_key} = require("${game_name}.${uncapitalize(game_obj_key)}"),
% endfor
    }
% endif
end

% for function_name, function_parms in obj['functions'].items():
--- ${function_parms['description']}
% if 'arguments' in function_parms:
% for arg_parms in function_parms['arguments']:
-- @param {${shared['lua']['type'](arg_parms['type'])}} ${arg_parms['name']}: ${arg_parms['description']}
% endfor
% endif
% if function_parms['returns'] != None:
-- @returns <${shared['lua']['type'](function_parms['returns']['type'])}> ${function_parms['returns']['description']}
% endif
function ${obj_key}:${function_name}(${", ".join(function_parms['argument_names'])})
    return ${shared['lua']['cast'](function_parms['returns']['type']) if function_parms['returns'] != None else ""}(self._client:runOnServer(self, "${function_name}", {
% for argument_name in function_parms['argument_names']:
        ${argument_name} = ${argument_name},
% endfor
    }))
end
% endfor

${merge("-- ", "functions", "-- if you want to add any client side logic (such as checking functions) this is where you can add them")}

return ${obj_key}
