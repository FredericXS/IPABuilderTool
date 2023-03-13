import os

shScript = './BuildIPA/build-ipa.sh'

def readAndWrite(target, replaceWith):
    with open(shScript, 'r') as file:
      data = file.read()
      data = data.replace(target, replaceWith)

      with open(shScript, 'w') as file:
          file.write(data)

def modifyAndExecuteSh(appName, appPath):
    readAndWrite('BuiltApp', appName)
    readAndWrite('CurrentLocation', appPath)
    os.system(f'sh {shScript}')
    readAndWrite(appName, 'BuiltApp')
    readAndWrite(appPath, 'CurrentLocation')