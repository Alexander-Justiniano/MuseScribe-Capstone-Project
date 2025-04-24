<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- c:out ; c:forEach etc. --> 
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!-- Formatting (dates) --> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"  %>
<!-- form:form TODO: REMOVE IF NO FORMS ARE TO BE SUBMITTED-->
<!-- %@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%> -->
<!-- for rendering errors on PUT routes -->
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>


<!-- TODO: 

-Routes for appropriate links need to be added 
-Work on midi file upload feature
-Import ABCjs library and work on incorporating its features
-Work on DarkMode feature 
-Finish Tooltip feature
-Track playback and transcription polish
-Work on sheet music download feature

-->


<head>
	<meta charset="UTF-8">
	<title>Musescribe Homepage</title>
	<link href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css" rel="stylesheet">
	<link href="/CSS/style.css" rel="stylesheet">
	<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.28.0/feather.min.js"></script>
	<link href="https://www.abcjs.net/abcjs-audio.css" media="all" rel="stylesheet" type="text/css">
	<script src="https://www.abcjs.net/abcjs-basic-min.js"></script>
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	
	<link rel="icon" type="image/png" href="/IMGS/favicon_io/favicon-96x96.png" sizes="96x96" />
	<link rel="icon" type="image/svg+xml" href="/IMGS/favicon_io/favicon.svg" />
	<link rel="shortcut icon" href="/IMGS/favicon_io/favicon.ico" />
	<link rel="apple-touch-icon" sizes="180x180" href="/IMGS/favicon_io/apple-touch-icon.png" />
	<meta name="apple-mobile-web-app-title" content="MuseScribe" />
	<link rel="manifest" href="/IMGS/favicon_io/site.webmanifest" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">

</head>
<style>
/* Custom style for dragover state */
.dragover {
	background-color: #d1fae5 !important; /* Tailwind green-100 */
	border-color: #10b981 !important;     /* Tailwind green-500 */
}
/* Custom style for error state */
.dragerror {
	background-color: #fee2e2 !important; /* Tailwind red-200 */
	border-color: #f87171 !important;     /* Tailwind red-400 */
}
.abcjs-midi-tempo{
color:#454545;
}

.abcjs-inline-audio {
    background-color: rgba(0, 0, 0, 0.30);
}

.abcjs-inline-audio .abcjs-midi-progress-background {
    background-color: #d54c4c;
}
.sheet-card{
	display: inline-flex !important;
	max-width: 100%;
	max-width: 130px;
	height: 152px;
	cursor:pointer;
	position:relative;
}
.sm-sheet-card{
	display: inline-flex !important;
	padding: 0 !important;
	width: 130px !important;
	height: 152px;
	justify-content: center;
	background: #fff;
	border: 2pt solid #454545;
	opacity:65%;
	cursor:pointer;
	position:relative;
}
.sm-sheet-card:hover{
	opacity:100%; 
}

.sm-sheet-card::before {
	content:'';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: transparent;
  z-index: 10; /* Ensure it's above the canvas */
}
.abcjs-inline-audio {
    height: 35px;
}
.abcjs-btn {

    border-radius: .35rem;
}
.abcjs-btn {
    height: auto !important;
    padding: 4px 4px !important;
}
.abcjs-btn.abcjs-pushed{
	background-color: #898989 !important;	
}

#notebook-dropdown-btn svg.open{
	transform:rotate(270deg);
}
.notebooks-panel{
	height:0;
	overflow:hidden;
	padding:0;
}
.notebooks-panel.open{
	height:auto;
}
button{
	transition:all .15s ease-in-out;
}
button:disabled, button:disabled:hover{
	background:#e3e3e3;
	color:#939393;
	cursor:not-allowed;
	border-color:#e3e3e3;
}

@media (max-width: 640px) {
  .sm-sheet-card {
    width: 100px !important;
    height: 120px !important;
  }
  .abcjs-inline-audio {
	flex-wrap: wrap;
	height:auto;
	padding:8px;
  }
  span.abcjs-tempo-wrapper {
      width: 100%;
  }
  
  .sheet-card {
      	max-width: unset;
  }
}

</style>

  <body class="bg-gray-50 min-h-screen py-8 px-3">
	<!-- Modal for Drag-n-Drop Upload -->
   <div id="uploadModal" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 hidden z-40">
     <div class="bg-white w-96 p-6 rounded-lg relative">
       <!-- Close button -->
       <button id="closeModal" class="absolute top-0 right-2 text-gray-600 hover:text-gray-800 text-2xl">
         &times;
       </button>
       <!-- Upload Form with Drag-n-Drop Zone -->
       <form id="uploadForm" class="upload-audio" action="" method="POST" enctype="multipart/form-data">
         <div class="flex items-center justify-center w-full">
           <label id="modalDropZone" for="modal-dropzone-file" class="flex flex-col items-center justify-center w-full h-64 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100">
             <div id="modalDropZoneContent" class="flex flex-col items-center justify-center pt-5 pb-6">
			  <i data-feather="upload" class="w-8 h-8mb-4 text-gray-500"></i>
               <p class="mb-2 text-sm text-gray-500">
                 <span class="font-semibold">
                   Click to upload
                 </span>
                 or drag and drop
               </p>
               <p class="text-xs text-gray-500">
                 Only .wav or .mp3 files accepted
               </p>
             </div>
             <!-- File input accepts only .wav and .mp3 -->
             <input id="modal-dropzone-file" type="file" class="hidden" accept=".wav,.mp3,.mid,.midi"
             />
           </label>
         </div>
         <!-- Hidden Upload Button Revealed on File Drop/Selection -->
         <div id="modalUploadButtonContainer" class="flex items-center justify-center mt-4"
         style="display: none;">
           <button type="submit" id="modalUploadButton" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
             Upload
           </button>
         </div>
       </form>
     </div>
   </div><!--Upload Modal End-->
   
   <div id="newNotebookForm" class="hidden p-4 bg-white rounded shadow-lg fixed top-1/2 left-1/2 -translate-1/2 z-40">
     <label for="newNotebookTitle" class="block mb-1 font-medium">Notebook Title</label>
     <input type="text" id="newNotebookTitle" class="w-full border rounded p-2 mb-2" placeholder="Enter a title…" />
     <div class="flex justify-end space-x-2">
       <button id="cancelNewNotebook" class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400">Cancel</button>
       <button id="submitNewNotebook" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">Create</button>
     </div>
   </div>
   
    <div class="max-w-6xl mx-auto space-y-6">
      <!-- Header -->
      <div class="flex justify-between items-center">
        <img src="/IMGS/musescribe-logo.svg" alt="MuseScribe Logo" class="w-60">
        <div>
          <!-- TODO: Add Dark Mode feature button -->
          <div>
            <button class="Dark Mode" data-name="Dark Mode">
            </button>
          </div>
          <div class="dropdown">
            <button class="p-2 rounded-lg hover:bg-gray-300 dropdown-btn">
              <i data-feather="settings" class="w-5 h-5">
              </i>
            </button>
            <div class="dropdown-content">
              <a class="hover:bg-gray-300" href="#">
                Profile
              </a>
              <a class="hover:bg-gray-300" href="#">
                Settings
              </a>
              <a class="hover:bg-gray-300" href="/login">
                Login
              </a>
              <button class="hover:bg-gray-300" style="display: block;padding: 10px;text-decoration: none;color: black;width: 100%;text-align: left;"
              id="fetchDataBtn">
                Fetch Data
              </button>
            </div>
          </div>
        </div>
      </div>
      <!-- Main Content -->
      <div class="grid grid-cols-1 gap-6">
        <!-- Sheet Music -->
        <div class="bg-white rounded-lg shadow-sm p-4 sm:p-6 space-y-4">
          <c:if test="${not empty user.name}">
            <h2 class="text-xl font-semibold text-gray-900">
              Welcome ${user.name}!
            </h2>
          </c:if>
          <div id="music-sheet" class="relative sheet-music-placeholder h-64 rounded-lg bg-red-50 border-2 border-red-400 flex justify-center">
            <div id="uploadShortcutWrapper" class="text-xl absolute left-1/2 top-1/2 flex flex-col sm:flex-row gap-5"
            style="transform: translate(-50%, -50%);">
			<div  class="relative">
              <button class="chooseRecordOption bg-red-500 border-2 border-red-400 rounded p-3 px-4 text-white text-4xl sm:text-xl">
                Record
              </button>
            </div>
              <button class="upload-button bg-white rounded p-3 px-4 border-2 border-red-400 text-red-600 text-4xl sm:text-xl">
                Upload
              </button>
            </div>
            <!-- Loading indicator shown while processing requests -->
            <div id="loading" class="flex items-center" style="display:none;">
              <p>
                Processing... Please wait.
              </p>
              <img src="https://i.gifer.com/ZZ5H.gif" alt="Loading icon" class="w-6 ml-2">
            </div>
          </div>
          <!-- User Music Sheets -->
          <div>
            <c:if test="${notebooks.size() > 0}">
              <div id="notebook-carousel" class="border-2 rounded">
                <h3 class="text-center text-lg bg-gray-200 p-1">
                  Your Notebooks
                </h3>
				
                <ul class="gap-4 grid grid-cols-2 md:grid-cols-5 lg:grid-cols-7 p-4">
					<li id="createNewNotebook" class="sheet-card p-2 text-center uppercase rounded-lg bg-gray-200 text-gray-900 border-gray-100 items-center font-bold flex-col justify-between border-2  hover:border-gray-800  transform transition-all duration-1500"
					>
					  Create a new notebook
					  <span  class="text-sm text-white font-normal bg-gray-700 rounded-lg px-2 py-1 hover:bg-transparent border-2 border-gray-700 hover:text-gray-800">
					    New Book
					  </span>
					</li>
				<!--Render Notebooks-->
                  <c:forEach var="nb" items="${notebooks}">
                    <li class="notebook-sheet-card sheet-card p-2 text-center uppercase rounded-lg bg-blue-100 text-blue-900 border-blue-100 items-center font-bold flex-col justify-between border-2  hover:border-blue-800  transform transition-all duration-1500"
                    data-notebook-id="${nb.id}" data-notebook-title="${nb.title}">
                      ${nb.title}
                      <span class="text-sm text-white font-normal bg-blue-700 rounded-lg px-2 py-1 hover:bg-transparent border-2 border-blue-700 hover:text-blue-800">
                        Open Book
                      </span>
                    </li>
                  </c:forEach>

                </ul>
              </div>
            </c:if>
            <div id="music-sheet-carousel" class="border rounded" style="display:none;">
              <div class="bg-gray-200 flex p-2 text-center justify-between">
                <div class="flex items-center">					
					<button id='backToNotebooks' class="text-underline rounded bg-white mr-4 px-1  py-0 hover:bg-gray-100 transition-all duration-1500 text-sm">
	                  Back
	                </button>
	                <h3 id="current-notebook-title" class="text-center text-xl"></h3>
				</div>
				<button id="notebook-dropdown-btn" class="px-1 hover:bg-gray-100 rounded-full">
					<i data-feather="chevron-down" class="sm:w-5 sm:h-5 "></i>
				</button>
              </div>
              <div class="notebooks-panel open">
				<!--Render Music Sheets-->
                <ul class="gap-4 grid grid-cols-7 p-4"></ul>
              </div>
            </div>
          </div>
          <!-- ABC.js Audio Controls -->
          <div class=" sticky bottom-0 rounded pb-4 ">
            <div id="musicsheet-controls-panel" class="bg-gray-50 shadow rounded px-3 pt-3">
              <div id="audio-controls"></div>

              <!--Buttons-->
              <div class="flex flex-col py-3 ">
                <div class="button-wrapper flex gap-2 justify-between sm:justify-start">
                  <!-- Edit -->
                  <!--<button class="p-2 border rounded-lg hover:bg-yellow-200" data-tooltip="Edit">
                    <i data-feather="edit-2" class="sm:w-5 sm:h-5"></i>
                  </button>-->
                  <!-- Download -->
                  <button id="midi-link" class="p-2 border rounded-lg hover:bg-purple-200"
                  data-tooltip="Download">
                    <i data-feather="download" class="sm:w-5 sm:h-5"></i>
                  </button>
                  <!-- Save -->
                  <button 
					  id="music-save" 
					  class="p-2 border rounded-lg hover:bg-blue-200"
	                  data-tooltip="Save"
				  >
                    <i data-feather="save" class="sm:w-5 sm:h-5"></i>
                  </button>
                  <!-- Record -->
				<div  class="relative">
					<div id="chooseRecordOptionModal" style="display:none;" class="z-40 bg-white flex justify-between align-center flex-col border-2 shadow text-center rounded absolute p-2 -top-32 w-52 h-auto transform left-1/2 -translate-x-1/2">
						<span>Choose an input device</span>
						<div class="flex flex-col">
							<button class="align-center border-2 gap-2.5 inline-flex justify-center mt-2.5 py-1.5 rounded recordButton" id="recordButton">
								<img src="/IMGS/mic-icon.svg" alt="mic icon" width="20px" height="auto" /> Microphone
							</button>
							<button class="align-center border-2 gap-2.5 inline-flex justify-center mt-2.5 py-1.5 rounded" id="recordMidiButton">
								<img src="/IMGS/keyboard-icon.svg" alt="midi icon" width="20px" height="auto" /> Midi
							</button>
						</div>
					</div>
					<button class="chooseRecordOption p-2 border rounded-lg hover:bg-red-200 relative" data-tooltip="Record">
						<i data-feather="mic" class="sm:w-5 sm:h-5"></i>
					</button>
				</div>
                  <!-- Upload -->
                  <button id="upload-audio" class="p-2 border upload-button rounded-lg hover:bg-green-200" data-tooltip="Upload Audio (.mp3 | .wav)">
                    <i data-feather="upload" class="sm:w-5 sm:h-5"></i>
                  </button>
                </div>
                  <!-- Recording Controls: Initially hidden -->
                  <div id="recording-controls" class="inline-flex gap-2 my-2" style="display: none;">
                    <button id="stop-recording" class="p-2 rounded-lg border hover:bg-gray-200">
                      <i data-feather="pause-circle" class="sm:w-5 sm:h-5"></i>
                    </button>
                    <button id="reset-recording" class="p-2 rounded-lg border hover:bg-gray-200">
                      <i data-feather="refresh-ccw" class="sm:w-5 sm:h-5"></i>
                    </button>
                    <button id="submit-recording" class="p-2 rounded-lg border bg-blue-600 text-white hover:bg-blue-500"
                    style="display: none;">
                      Transcribe
                    </button>
                  </div>
                <!-- Waveform canvas -->
                <canvas id="waveform" style="display:none;height: 100px; border: 2pt solid #e94848; border-radius: 1rem; background: #fff0f0;">
                </canvas>
              </div>
            </div>
          </div>
		  <!-- Header Editor Section -->
		   <div id="settings-panel" class="bg-white p-4 rounded shadow">
		     <h2 class="text-xl font-bold mb-4">Settings</h2>
		     <div class="grid sm:grid-cols-2 gap-4">
		       <label>Title: <input class="border p-1 w-full rounded" id="abc-title" placeholder="Music Sheet Title"></label>
		       <label>Composer: <input class="border p-1 w-full rounded" id="abc-composer" placeholder="Music Sheet Writers Name"></label>
		       <label>Meter:
		         <select class="border p-1 w-full rounded" id="abc-meter">
					<option disabled selected>Choose an option</option>
					<option value="2/4">2/4</option>
				   <option value="3/4">3/4</option>
				   <option value="4/4">4/4</option>
				   <option value="6/8">6/8</option>
				   <option value="9/8">9/8</option>
				   <option value="12/8">12/8</option>
		         </select>
		       </label>
		       <label>Note Length:
		         <select class="border p-1 w-full rounded" id="abc-length">
					<option disabled selected>Choose an option</option>
		           <option value="1/1">1/1</option>
				   <option value="1/2">1/2</option>
				   <option value="1/4">1/4</option>
				   <option value="1/8">1/8</option>
				   <option value="1/16">1/16</option>
		         </select>
		       </label>
		       <label>Tempo:
		         <input type="number" class="border p-1 w-full rounded" id="abc-tempo" min="30" max="300" step="1" value="150" placeholder="e.g. 150">
		       </label>
		       <label>Key:
		         <select class="border p-1 w-full rounded" id="abc-key">
					<option disabled selected>Choose an option</option>
		           <option value="C">C</option>
				   <option value="G">G</option>
				   <option value="D">D</option>
				   <option value="A">A</option>
				   <option value="E">E</option>
				   <option value="B">B</option>
				   <option value="F#">F#</option>
				   <option value="C#">C#</option>
		           <option value="F">F</option>
				   <option value="Bb">Bb</option>
				   <option value="Bm">Bm</option>
				   <option value="Eb">Eb</option>
				   <option value="Ab">Ab</option>
				   <option value="Db">Db</option>
				   <option value="Gb">Gb</option>
				   <option value="Cb">Cb</option>
		         </select>
		       </label>
		     </div>
			<div class="flex gap-4 justify-between items-center align-center">
				 <div class="flex gap-2">
				     <button id="updateAbcHeader" class="mt-4 bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Update</button>
				     <button id="deleteMusicSheet" class="mt-4 border-2 border-red-500 flex gap-2 text-red-600 px-2 py-2 rounded hover:bg-red-500 hover:text-white"><i data-feather="trash" class="sm:w-5 sm:h-5"></i> Delete Sheet Music</button>				
				 </div>
			     <button id="deleteNoteBook" class="mt-4 border-2 border-red-500 text-red-600 px-2 py-2 flex gap-2 rounded hover:bg-red-500 hover:text-white"><i data-feather="trash" class="sm:w-5 sm:h-5"></i> Delete Notebook</button>				
			</div>
		   </div>
       
        </div>
      </div>
    </div>
    <!-- Inline Scripts -->
	<script>  const userId = '<c:out value="${user.id}"/>';   </script>
    <script src="/JS/modal-script.js"> </script>
    <script src="/JS/recorder.js"></script>
    <script src="/JS/upload-audio.js"></script>
    <script src="/CSS/script.js"></script>

    <script>
      //Here is javascript to interface MIDI API
      /*				
		requestMIDIAccess()
		requestMIDIAccess(MIDIOptions)
		
		navigator.permissions.query({ name: "midi", sysex: true }).then((result) => {
		  if (result.state === "granted") {
		    // Access granted.
		  } else if (result.state === "prompt") {
		    // Using API will prompt for permission
		  }
		  // Permission was denied by user prompt or permission policy
		});
		
		let midi = null; // global MIDIAccess object
		function onMIDISuccess(midiAccess) {
		  console.log("MIDI ready!");
		  midi = midiAccess; // store in the global (in real usage, would probably keep in an object instance)
		}

		function onMIDIFailure(msg) {
		  console.error(`Failed to get MIDI access - ${msg}`);
		}

		navigator.requestMIDIAccess().then(onMIDISuccess, onMIDIFailure);
		
		function listInputsAndOutputs(midiAccess) {
		  for (const entry of midiAccess.inputs) {
		    const input = entry[1];
		    console.log(
		      `Input port [type:'${input.type}']` +
		        ` id:'${input.id}'` +
		        ` manufacturer:'${input.manufacturer}'` +
		        ` name:'${input.name}'` +
		        ` version:'${input.version}'`,
		    );
		  }
		  for (const entry of midiAccess.outputs) {
		    const output = entry[1];
		    console.log(
		      `Output port [type:'${output.type}'] id:'${output.id}' manufacturer:'${output.manufacturer}' name:'${output.name}' version:'${output.version}'`,
		    );
		  }
		}
		
		function onMIDIMessage(event) {
		  let str = `MIDI message received at timestamp ${event.timeStamp}[${event.data.length} bytes]: `;
		  for (const character of event.data) {
		    str += `0x${character.toString(16)} `;
		  }
		  console.log(str);
		}

		function startLoggingMIDIInput(midiAccess) {
		  midiAccess.inputs.forEach((entry) => {
		    entry.onmidimessage = onMIDIMessage;
		  });
		}
		*/
      
    </script>
  </body>
</html>