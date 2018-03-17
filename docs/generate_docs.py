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
a = a.replace("___GAMES___", '  \n'.join('<li><a href="{}/">{}</a></li>'.format(n, n[0].upper() + n[1:]) for n in game_names))
a = a.replace("___README___", html_readme)
a = a.replace("___YEAR___", str(datetime.datetime.now().year))
new_index_contents = a

with open("./output/index.html", "w+") as new_index:
    new_index.write(new_index_contents)

for lower_game_name in game_names:
    game_name = lower_game_name[0].upper() + lower_game_name[1:]

    with open("./config.ld", "w+") as config:
        config.write("""
project = [[<p style="margin: 0.25em;"><a href="../">Lua Joueur Client</a></p>
<p style="font-size: 0.675em; margin: 0.5em;">{game_name} Game</p>
]]
title = '{game_name} Lua Client'
-- full_descriptions = [[{html_readme}]]
""".format(
    html_readme='hi' or html_readme,
    game_name=game_name
))

    run(['ldoc --dir ./output/{lower_game_name} --config ./config.ld --verbose ../games/{lower_game_name}'.format(
        lower_game_name=lower_game_name
    )], shell=True)

    # cleanup files we made
    os.remove("config.ld")
