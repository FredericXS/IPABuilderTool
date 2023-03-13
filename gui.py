import xcodeproj
import tkinter as tk
from tkinter import *
from tkinter import filedialog
from makeipa import *

def createButton(projName, projPath):
    selectFileButton.destroy()

    def createIPA():
        modifyAndExecuteSh(projName, projPath)
        createdLabel = tk.Label(root, text='IPA created!', font=('Arial', 14))
        createdLabel.place(relx=0.5, rely=0.85, anchor=tk.CENTER)

    createIPAButton = tk.Button(root, text='Create IPA', command=createIPA)
    createIPAButton.place(relx=0.5, rely=0.5, anchor=tk.CENTER)

def selectFile():
    file_path = filedialog.askopenfilename()
    project = xcodeproj.XcodeProject(file_path)

    projName = project.project.targets[0].name
    replaceName = f'/{projName}.xcodeproj'
    projPath = project.path.replace(replaceName, '')

    label = tk.Label(root, text=f'File selected: {projPath}/{projName}.xcodeproj', font=('Arial', 14))
    label.place(relx=0.5, rely=0.65, anchor=tk.CENTER)
    createButton(projName, projPath)



root = tk.Tk()
root.title('IPA Builder Tool')

width = 600
height = 400
screen_width = root.winfo_screenwidth()
screen_height = root.winfo_screenheight()
x_coordinate = (screen_width/2) - (width/2)
y_coordinate = (screen_height/2) - (height/2)
root.geometry('%dx%d+%d+%d' % (width, height, x_coordinate, y_coordinate))

description = tk.Label(root, text='Create .ipa files easily!', font=('Arial', 24))
description.place(relx=0.5, rely=0.25, anchor=tk.CENTER)

selectFileButton = tk.Button(root, text='Select File', command=selectFile)
selectFileButton.place(relx=0.5, rely=0.5, anchor=tk.CENTER)

root.mainloop()