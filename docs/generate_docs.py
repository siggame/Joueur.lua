import os
import os.path
import datetime
import shutil
import subprocess
import re
import markdown # pip module
import sys

def run(*args, **kwargs):
    error_code = subprocess.call(*args, **kwargs)
    if error_code != 0: # an error happened
        sys.exit(error_code)

def splitall(path):
    allparts = []
    while 1:
        parts = os.path.split(path)
        if parts[0] == path:  # sentinel for absolute paths
            allparts.insert(0, parts[0])
            break
        elif parts[1] == path: # sentinel for relative paths
            allparts.insert(0, parts[1])
            break
        else:
            path = parts[0]
            allparts.insert(0, parts[1])
    return allparts

if os.path.isdir("./output"):
    shutil.rmtree("./output")
os.makedirs("./output")

shutil.copyfile("./ldoc.css", "./output/ldoc.css")

game_names = next(os.walk('../games'))[1]

with open("./index.html", "r") as index_file:
   index_contents = index_file.read()

with open("../README.md", "r") as md_readme:
    readme = md_readme.read()

html_readme = markdown.markdown(readme)

a = index_contents
a = a.replace("___GAMES___", '  \n'.join('<li><a href="{}/">{}</a></li>'.format(n, n[0].upper() + n[1:]) for n in sorted(game_names)))
a = a.replace("___README___", html_readme)
a = a.replace("___YEAR___", str(datetime.datetime.now().year))
new_index_contents = a

with open("./output/index.html", "w+") as new_index:
    new_index.write(new_index_contents)

game_desc_re = re.compile('(?<=--- ).*')

for lower_game_name in game_names:
    game_name = lower_game_name[0].upper() + lower_game_name[1:]

    with open("../games/{}/game.lua".format(lower_game_name), "r") as file:
        description = game_desc_re.search(file.read()).group()

    with open("./config.ld", "w+") as config:
        config.write("""
project = [[<p style="margin: 0.25em;"><a href="../">Lua Joueur Client</a></p>
<p style="font-size: 0.675em; margin: 0.5em;">{game_name} Game</p>
]]
title = '{game_name} — Lua Joueur Client'
full_description = [[
<h1>Game <code>{game_name}</code></h1>
<p>{description}</p>
<h2>Rules</h2>
<p>
The full game rules for {game_name} can be found on <a href="https://github.com/siggame/Cadre/blob/master/Games/{game_name}/rules.md">GitHub</a>.
</p>
<p>
Additional materials, such as the <a href="https://github.com/siggame/Cadre/blob/master/Games/{game_name}/story.md">story</a> and <a href="https://github.com/siggame/Cadre/blob/master/Games/{game_name}/creer.yaml">game template</a> can be found on <a href="https://github.com/siggame/Cadre/blob/master/Games/{game_name}/">GitHub</a> as well.
</p>
]]
""".format(
    game_name=game_name,
    description=description
))

    run(['ldoc --dir ./output/{lower_game_name} --config ./config.ld --verbose ../games/{lower_game_name}'.format(
        lower_game_name=lower_game_name
    )], shell=True)

    # cleanup files we made
    os.remove("config.ld")

# inject favicon into output
output_path="./output"
HEAD_TAG = "<head>"
shutil.copyfile('favicon.ico', os.path.join(output_path, 'favicon.ico'))
dot_dirs = len(splitall(output_path))
for root, dirnames, filenames in os.walk(output_path):
    root = os.path.normcase(root)
    for filename in filenames:
        if not filename.endswith('.html'):
            continue

        n = (len(splitall(root)) - dot_dirs)
        with open(os.path.join(root, filename), "r+") as file:
            contents = file.read()
            index = contents.find(HEAD_TAG) + len(HEAD_TAG)
            contents = contents[:index] + """
<link rel="shortcut icon" href="./{}favicon.ico" type="image/x-icon" />
""".format("../" * n) + contents[index:]
            file.seek(0)
            file.write(contents)

print("lua docs generated")
