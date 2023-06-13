# Transcript-File-Generator (for MDT)

<img width="978" alt="Layout" src="https://github.com/BenKnighton/M.E.R.L.I.N/assets/131706686/b495c6d3-14e6-4dee-bde0-1b060f7e91e9">

Using the power of Artificial Intelligence, The generators are use to create transcript files. For optical character recognition (recognising words), and object detection, the generates take only image files from a folder containing all the files, and create a transcript file, which looks a bit like this:

### This file is a simple text file, with a list of the filename, a <break> and a transcript.

A transcript file will be generated and saved automatically to the same folder as where the folder full of the images. This folder should be under the umbrella folder which is specified in Artificial MDT.
For this code to work, you need to install the YOLOv3 model (YOLOv3.mlmodel Storing model weights using full precision (32bit) floating point numbers. 248.4MB) from Apple, which can be found here: https://ml-assets.apple.com/coreml/models/Image/ObjectDetection/YOLOv3/YOLOv3.mlmodel
 
This then needs to be dragged inside of the XCode environment. I would recommend watching a video on how to use Neural network models in XCode like this one: https://www.youtube.com/watch?v=uRFxyk-xGE4&list=PL2F6YCOKI3dgcskDbcjahBI9gTtz8_Ngh&index=41

