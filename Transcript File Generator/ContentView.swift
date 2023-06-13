//
//  ContentView.swift
//  Transcript File Generator
//
//  Created by Ben Knighton on 13/06/2023.
//

import SwiftUI
import AVFoundation
import Speech
import Vision

struct GenerateTranscriptionFiles: View {
    @State var folderPath: String = ""
    @State private var selectedURL: URL?
    @State private var transcription = ""
    @State private var isTranscribing = false
    
    @State private var foregroundColor = Color.black
    
    var body: some View {
        
        ZStack {
            Image("Wallpaper")
                .resizable()
                .scaledToFill() //comment?
                .edgesIgnoringSafeArea(.all)
            
            
    
            
            VStack {
                VStack{
                    Text("Optical Character Recognition")
                        .foregroundColor(foregroundColor)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Generates the Optical Character Recognition (OCR) file, which is located in the same chosen directory as the one you choose when the buttton is pressed. Only works on images")
                        .foregroundColor(foregroundColor)
                        .padding()
                        .frame(maxWidth: 400, alignment: .leading)
                    
                    Button(action: {
                        
                        folderPath = NSOpenPanelDir()
                        print(folderPath)
                        let files = getFiles(path: folderPath)
                        print(files)
                        let paths = files.map {folderPath + "/" + $0}
                        let supportedImageTypes = ["jpg", "jpeg", "png", "gif", "tiff", "bmp", "heif"]
                        let filteredImages = generalFileFilter(from: paths, types: supportedImageTypes)
                        
                        var fileTranscript = ""
                        //for loop over all filepaths in array
                        for imagePath in filteredImages {
                            print(imagePath)
                            //extractTextFromImage(path: filepath)
                            let result = extractTextFromImage(imagePath: imagePath)
                            let transcript = result.joined(separator: " ")
                            print(transcript)
                            fileTranscript += "\(imagePath) <break> \(transcript)\n"
                            //add to transcript file
                        }
                        
                        let fileContents = fileTranscript.trimmingCharacters(in: .newlines)
                        print(fileContents)
                        saveFile(path: "\(folderPath)/OCR.txt", contents: fileContents)
                        
                        
                        
                    }, label: {
                        Text("Generate OCR File")
                            .foregroundColor(.white)
                            .padding([.leading, .bottom, .trailing])
                            .bold()
                    }).background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(
                                LinearGradient(gradient: Gradient(colors: [Color(hex:"#4c0cb3"), Color(hex: "#9815d8")]), startPoint: .bottom, endPoint: .top)
                            )
                    )
                    
                    
                    
                }
                .padding()
                .frame(width: 400)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white) // Choose your desired color
                )
                .padding()
                
                
                VStack{
                    Text("Detect Objects")
                        .foregroundColor(foregroundColor)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Generates the Object Detection (OD) file, which is\nlocated in the same folder as the one selected when the button is pressed. Only works on images")
                        .foregroundColor(foregroundColor)
                        .padding()
                        .frame(maxWidth: 400, alignment: .leading)
                    
                    Button(action: {
                        
                        folderPath = NSOpenPanelDir()
                        print(folderPath)
                        let files = getFiles(path: folderPath)
                        print(files)
                        let paths = files.map {folderPath + "/" + $0}
                        //file filter movie files
                        let supportedImageTypes = ["jpg", "jpeg", "png", "gif", "tiff", "bmp", "heif"]
                        let filteredImages = generalFileFilter(from: paths, types: supportedImageTypes)
                        
                        var fileTranscript = ""
                        //for loop over all filepaths in array
                        for imagePath in filteredImages {
                            print(imagePath)
                            //recognizeObjects(path: filepath)
                            //add to transcript file
                            let result = recognizeObjects(imagePath: imagePath)
                            let transcript = result.joined(separator: " ")
                            print(transcript)
                            fileTranscript += "\(imagePath) <break> \(transcript)\n"
                        }
                        
                        //saveFile(path: filePath, contents: fileContents)
                        let fileContents = fileTranscript.trimmingCharacters(in: .newlines)
                        print(fileContents)
                        saveFile(path: "\(folderPath)/OD.txt", contents: fileContents)
                        
                        
                    }, label: {
                        Text("Generate OD File")
                            .foregroundColor(.white)
                            .padding([.leading, .bottom, .trailing])
                            .bold()
                    }).background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(
                                LinearGradient(gradient: Gradient(colors: [Color(hex:"#00E2C4"), Color(hex: "#44E8A2")]), startPoint: .bottom, endPoint: .top)
                            )
                    )
                    
                    
                    
                    
                }
                .padding()
                .frame(width: 400)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white) // Choose your desired color
                )
                .padding()
                
                
                VStack{
                    Text("Speech Recognition")
                        .foregroundColor(foregroundColor)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Generates the a file called SOUND, which is the trascription of the audio file, only works on audiofiles")
                        .foregroundColor(foregroundColor)
                        .padding()
                        .frame(maxWidth: 400, alignment: .leading)
                    
                    Button(action: {
                        
                        //old code goes here
                        print("transcribing audio file....")
                        
                        
                    }, label: {
                        Text("Transcribe single Audio file")
                            .foregroundColor(.white)
                            .padding([.leading, .bottom, .trailing])
                            .bold()
                    })
                    .disabled(isTranscribing)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(
                                LinearGradient(gradient: Gradient(colors: [Color(hex:"#1414cb"), Color(hex: "#1cbbb1")]), startPoint: .bottom, endPoint: .top)
                            )
                    )
                    
                
                    
                    
                }
                .padding()
                .frame(width: 400)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white) // Choose your desired color
                )
                .padding()
                
                
            }
        }
    }
    
    
    
    
    func transcribeAudioFile(audioFilePath: String) {
        let audioURL = URL(fileURLWithPath: audioFilePath)
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        let request = SFSpeechURLRecognitionRequest(url: audioURL)
        recognizer?.recognitionTask(with: request) { [self] result, error in
            if let error = error {
                print("Recognition error: \(error.localizedDescription)")
                return
            }
    
            if let result = result, result.isFinal {
                transcription = result.bestTranscription.formattedString
                isTranscribing = false
                saveTranscriptToFile(audioFilename: audioFilePath, transcript: transcription)
    
            }
            isTranscribing = true
        }
    }
    
    
    func saveTranscriptToFile(audioFilename: String, transcript: String) {
        let fileManager = FileManager.default
    
        let url = URL(fileURLWithPath: audioFilename)
        let fileName = url.deletingPathExtension().lastPathComponent
    
        let audioURL = URL(fileURLWithPath: audioFilename)
        let parentDirectory = audioURL.deletingLastPathComponent().path
        let soundFilesDirectoryPath = "\(parentDirectory)/SoundFiles"
    
        // Create directory if it doesn't exist
        if !fileManager.fileExists(atPath: soundFilesDirectoryPath) {
            do {
                try fileManager.createDirectory(atPath: soundFilesDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating directory: \(error.localizedDescription)")
                return
            }
        }
    
        let soundFilesDirectory = URL(fileURLWithPath: soundFilesDirectoryPath).appendingPathComponent("\(fileName).txt").path
        let fileURL = URL(fileURLWithPath: soundFilesDirectory)
    
        do {
            if fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.removeItem(at: fileURL)
            }
    
            let data = "\(audioFilename) <break> \(transcript)".data(using: .utf8)
            try data?.write(to: fileURL)
    
        } catch {
            print("Error saving transcript to file: \(error.localizedDescription)")
        }
        isTranscribing = false
    
        let seconds = 0.1
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            isTranscribing = false
        }
    }
    

    
    
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GenerateTranscriptionFiles()
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789abcdefABCDEF").inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}






//these are the functions for structures; converters, transcriptions, and file filters mostly

func NSOpenPanelDir() -> String {
    let panel = NSOpenPanel()
    panel.title = "Please select a text file."
    panel.canChooseDirectories = true
    panel.canChooseFiles = false
    panel.allowsMultipleSelection = true
    
    if case .OK = panel.runModal() {
        if !panel.urls.isEmpty {
            return panel.urls[0].path
            
        } else {
            return ""
        }
    }
    return ""
}

func getFiles(path:String) -> [String] {
    do {
        let files = try FileManager.default.contentsOfDirectory(atPath: path)
        return files
    } catch {
        print("Error: \(error.localizedDescription)")
        return []
    }
}


func saveFile(path: String, contents: String) -> Void {
    do {
        try contents.write(toFile: path, atomically: true, encoding: .utf8)
        print("File saved successfully.")
    } catch {
        print("Error writing to file: \(error)")
    }
}



func convertAudio(path: String) {
    let url = URL(fileURLWithPath: path)
    let outputURL = url.deletingPathExtension().appendingPathExtension("wav")
    
    var error : OSStatus = noErr
    var destinationFile : ExtAudioFileRef? = nil
    var sourceFile : ExtAudioFileRef? = nil

    var srcFormat : AudioStreamBasicDescription = AudioStreamBasicDescription()
    var dstFormat : AudioStreamBasicDescription = AudioStreamBasicDescription()

    ExtAudioFileOpenURL(url as CFURL, &sourceFile)

    var thePropertySize: UInt32 = UInt32(MemoryLayout.stride(ofValue: srcFormat))

    ExtAudioFileGetProperty(sourceFile!,
        kExtAudioFileProperty_FileDataFormat,
        &thePropertySize, &srcFormat)
    
    dstFormat.mSampleRate = 44100  //Set sample rate
    dstFormat.mFormatID = kAudioFormatLinearPCM
    dstFormat.mChannelsPerFrame = 1
    dstFormat.mBitsPerChannel = 16
    dstFormat.mBytesPerPacket = 2 * dstFormat.mChannelsPerFrame
    dstFormat.mBytesPerFrame = 2 * dstFormat.mChannelsPerFrame
    dstFormat.mFramesPerPacket = 1
    dstFormat.mFormatFlags = kLinearPCMFormatFlagIsPacked |
    kAudioFormatFlagIsSignedInteger


    // Create destination file
    error = ExtAudioFileCreateWithURL(
        outputURL as CFURL,
        kAudioFileWAVEType,
        &dstFormat,
        nil,
        AudioFileFlags.eraseFile.rawValue,
        &destinationFile)
    reportError(error: error)

    error = ExtAudioFileSetProperty(sourceFile!,
            kExtAudioFileProperty_ClientDataFormat,
            thePropertySize,
            &dstFormat)
    reportError(error: error)

    error = ExtAudioFileSetProperty(destinationFile!,
                                     kExtAudioFileProperty_ClientDataFormat,
                                    thePropertySize,
                                    &dstFormat)
    reportError(error: error)

    let bufferByteSize: UInt32 = 32768
//        var srcBuffer = [UInt8](repeating: 0, count: Int(bufferByteSize))
    var sourceFrameOffset: ULONG = 0

    while(true){
        var fillBufList = AudioBufferList(
            mNumberBuffers: 1,
            mBuffers: AudioBuffer(
                mNumberChannels: 2,
                mDataByteSize: UInt32(bufferByteSize),
                mData: nil
            )
        )
        var numFrames : UInt32 = 0

        if(dstFormat.mBytesPerFrame > 0){
            numFrames = bufferByteSize / dstFormat.mBytesPerFrame
        }

        // Allocate memory for the buffer
        let data = UnsafeMutableRawPointer.allocate(byteCount: Int(bufferByteSize), alignment: 1)
        fillBufList.mBuffers.mData = data

        error = ExtAudioFileRead(sourceFile!, &numFrames, &fillBufList)
        reportError(error: error)

        if(numFrames == 0){
            error = noErr;
            break;
        }
        
        sourceFrameOffset += numFrames
        error = ExtAudioFileWrite(destinationFile!, numFrames, &fillBufList)
        reportError(error: error)
    }
    
    error = ExtAudioFileDispose(destinationFile!)
    reportError(error: error)
    error = ExtAudioFileDispose(sourceFile!)
    reportError(error: error)
}

func reportError(error: OSStatus) {
    // Handle error
    if error != 0 {
        print(error)
    }
}

//file filters
func generalFileFilter(from filePaths: [String], types supportedTypes: [String]) -> [String] {
    let FilePaths = filePaths.filter { filePath in
        if let fileType = URL(fileURLWithPath: filePath).pathExtension.lowercased() as String?, supportedTypes.contains(fileType) {
            return true
        }
        return false
    }
    return FilePaths
}



func extractTextFromImage(imagePath: String) -> [String] {
    guard let image = NSImage(contentsOfFile: imagePath) else {
        print("Failed to load image at path: \(imagePath)")
        return []
    }

    var recognizedText = [String]()
    
    autoreleasepool {
        let request = VNRecognizeTextRequest(completionHandler: { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("Unexpected result type from text recognition request")
                return
            }
            
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                recognizedText.append(topCandidate.string)
            }
        })
        
        request.recognitionLevel = .accurate
//        request.recognitionLevel = .fast

        let handler = VNImageRequestHandler(data: image.tiffRepresentation!, options: [:])

        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform text recognition: \(error)")
            return []
        }
        return []
    }
    
    return recognizedText
}



func recognizeObjects(imagePath: String) -> [String] {
    print(imagePath)
    guard let image = NSImage(contentsOfFile: imagePath) else {
        print("Failed to load image at \(imagePath)")
        return []
    }

    var recognizedObjects = [String]()

    autoreleasepool {
        guard let ciImage = CIImage(data: image.tiffRepresentation!) else {
            print("Failed to create CIImage from NSImage")
            return []
        }

        let model: VNCoreMLModel
        do {
            // Replace "YOLOv3" with the actual name of your YOLOv3 model
            model = try VNCoreMLModel(for: YOLOv3(configuration: MLModelConfiguration()).model)
        } catch {
            print("Failed to load Vision ML model: \(error)")
            return []
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNRecognizedObjectObservation],
                  !results.isEmpty else {
                print("Failed to recognize objects in image")
                return
            }
            recognizedObjects = results.map { $0.labels[0].identifier }
        }

        let handler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform object recognition: \(error)")
            return []
        }
        return []
    }

    return recognizedObjects
}
