import os
import os.path
import shutil
import subprocess
import argparse
import re
import markdown # pip module

parser = argparse.ArgumentParser(description='Runs the python 3 client doc generation script.')
parser.add_argument('game', action='store', help='the name of the game you want to document. Must exist in ../games/')

args = parser.parse_args()

game_name = args.game[0].upper() + args.game[1:]
lower_game_name = game_name[0].lower() + game_name[1:]

if os.path.isdir("./output"):
    shutil.rmtree("./output")

with open("../README.md", "r") as md_readme:
    readme = md_readme.read()

readme = readme.replace("GAME_NAME", game_name).replace("game_name", lower_game_name)

html_readme = markdown.markdown(readme)

with open("./config.ld", "w+") as config:
    config.write('full_description=[[{}]]'.format(html_readme))

subprocess.call(['ldoc --dir ./output --title "{game_name} Lua Client" --project "{game_name} Lua Client" --config ./config.ld --verbose ../games/{lower_game_name}'.format(
    game_name=game_name,
    lower_game_name=lower_game_name,
)], shell=True)

# cleanup files we made
os.remove("config.ld")
#shutil.rmtree("./node_modules")
