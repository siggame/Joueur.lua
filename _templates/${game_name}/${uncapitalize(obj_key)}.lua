-- ${header}
-- This is a simple class to represent the ${obj_key} object in the game. You can extend it by adding utility functions here in this file.
<% parent_classes = obj['parentClasses'] %>
local class = require("utilities.class")
local makeCommand = require("utilities.command")
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

--- @class ${obj_key}: ${obj['description']}
local ${obj_key} = class(${", ".join(parent_classes)})

--- initializes a ${obj_key} with basic logic as provided by the Creer code generator
function ${obj_key}:init(...)
% for parent_class in reversed(parent_classes):
    ${parent_class}.init(self, ...)
% endfor


    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

% for attr_name, attr_parms in obj['attributes'].items():
<%
    attr_default = attr_parms["default"] if 'default' in attr_parms else None
    attr_type = attr_parms["type"]

    if attr_default == None:
        if attr_type == "string":
            attr_default = '""'
        elif attr_type == "array" or attr_type == "dictionary":
            attr_default = '{}'
        elif attr_type == "int" or attr_type == "float":
            attr_default = attr_default or 0
        elif attr_type == "boolean":
            attr_default = 'false'
        else:
            attr_default = "nil"
    else:
        if attr_type == "string":
            attr_default = '"' + attr_default + '"'
        elif attr_type == "boolean":
            attr_default = str(attr_default).lower()
%>    -- ${attr_parms['description']}
    self.${attr_name} = ${attr_default}
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
<%
    argument_string = ""
    argument_names = []
    if 'arguments' in function_parms:
        for arg_parms in function_parms['arguments']:
            argument_names.append(arg_parms['name'])
        argument_string = ", ".join(argument_names)
%>
--- ${function_parms['description']}
% if 'arguments' in function_parms:
% for arg_parms in function_parms['arguments']:
-- @param <${arg_parms['type']}> ${arg_parms['name']}: ${arg_parms['description']}
% endfor
% endif
function ${obj_key}:${function_name}(${argument_string})
    return makeCommand(self, "${function_name}", {
% for argument_name in argument_names:
        ${argument_name} = ${argument_name},
% endfor
    })
end
% endfor

return ${obj_key}
