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
	<link href="/css/style.css" rel="stylesheet">
	<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.28.0/feather.min.js"></script>
	<link href="https://www.abcjs.net/abcjs-audio.css" media="all" rel="stylesheet" type="text/css">
	<script src="https://www.abcjs.net/abcjs-basic-min.js"></script>
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	
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

.sm-sheet-card{
	display: inline-flex !important;
	padding: 0 !important;
	width: 130px !important;
	height: 152px;
	justify-content: center;
	background: #fff;
	border: 1pt solid #454545;
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

</style>
<body class="bg-gray-50 min-h-screen p-8">


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
						<i data-feather="settings" class="w-5 h-5"></i>
					</button>
				<div class="dropdown-content">
				<a class="hover:bg-gray-300" href="#">Profile</a>
				<a class="hover:bg-gray-300" href="#">Settings</a>
				<a class="hover:bg-gray-300" href="/login">Login</a>
				<button class="hover:bg-gray-300" style="display: block;padding: 10px;text-decoration: none;color: black;width: 100%;text-align: left;" id="fetchDataBtn" >Fetch Data</button>
				</div>
				</div>
			</div>
		</div>

		<!-- Main Content -->
		<div class="grid grid-cols-1  gap-6">
			<!-- Sheet Music -->
			<div class="bg-white rounded-lg shadow-sm p-6 space-y-4">
				
				<h2 class="text-xl font-semibold text-gray-900">
					<c:if test="${user.id}">${user.name}</c:if> Sheet Music
				</h2>

				<div id="music-sheet" class="relative sheet-music-placeholder h-64 rounded-lg bg-red-50 border-2 border-red-400 flex justify-center">
					
					<div id="uploadShortcutWrapper" class="text-xl absolute left-1/2 top-1/2" style="transform: translate(-50%, -50%);">
						<button class="recordButton bg-red-400 border-2 border-red-400 rounded p-3 px-4 text-white ">Record</button>  <button class="upload-button bg-white rounded p-3 px-4 border-2 border-red-400 text-red-600">Upload</button>
					</div>
					
					<!-- Loading indicator shown while processing requests -->
					<div id="loading" class="flex items-center" style="display:none;">
						<p>Processing... Please wait.</p>
						<img src="https://i.gifer.com/ZZ5H.gif" alt="Loading..." class="w-6 ml-2">
					</div>
				</div>
				
				<!-- User Music Sheets -->
				<div>
				    
				    <div id='music-sheet-carousel'>
						<h3>Saved Sheet Music</h3>
						<ul class="flex gap-4">
							<c:forEach var="sheet" items="${musicSheets}" varStatus="status">
							  
								<li class='sm-sheet-card overflow-hidden rounded' id='sheet-music-${status.index + 1}' data-sheet-idx='${status.index}' data-musicsheet-data='${sheet.abcNotation}' data-musicsheet-title='${sheet.title}'>${sheet.title}</li>
									
							</c:forEach>
						</ul>
					</div>
				</div>				
				
				
				<!-- ABC.js Audio Controls -->
				<div class=" sticky bottom-0 rounded pb-4 "> 
					<div class="bg-gray-50 shadow rounded px-3 pt-3 "> 
					<div id="audio-controls"></div>
					<!--Buttons-->
					<div class="flex flex-col pt-3">
					  <div class="button-wrapper">
					    <!-- Edit -->
					    <button class="p-2 border rounded-lg hover:bg-yellow-200" data-tooltip="Edit">
					      <i data-feather="edit-2" class="w-5 h-5"></i>
					    </button>
					    <!-- Download -->
					    <button id="midi-link" class="p-2 border rounded-lg hover:bg-purple-200" data-tooltip="Download">
					      <i data-feather="download" class="w-5 h-5"></i>
					    </button>
					    <!-- Save -->
					    <button id="music-save" class="p-2 border rounded-lg hover:bg-blue-200" data-tooltip="Save">
					      <i data-feather="save" class="w-5 h-5"></i>
					    </button>
					    <!-- Record -->
					    <button id="recordButton" class="p-2 recordButton border rounded-lg hover:bg-red-200 relative" data-tooltip="Record">
					      <i data-feather="mic" class="w-5 h-5"></i>
					    </button>
					    <!-- Upload -->
					    <button id="upload-audio" class="p-2 border upload-button rounded-lg hover:bg-green-200" data-tooltip="Upload Audio (.mp3 | .wav)">
					      <i data-feather="upload" class="w-5 h-5"></i>
					    </button>
						  <!-- Recording Controls: Initially hidden -->
						  <div id="recording-controls" class="inline-flex" style="display: none;" class="flex gap-2">
						    <button id="stop-recording" class="p-2 rounded-lg border hover:bg-gray-200">Stop</button>
						    <button id="reset-recording" class="p-2 rounded-lg border hover:bg-gray-200">Reset</button>
						    <button id="submit-recording" class="p-2 rounded-lg border hover:bg-gray-200" style="display: none;">Submit</button>
						  </div>
					  </div>
					
					  <!-- Waveform canvas -->
					  <canvas id="waveform" style="display:none;height: 100px; border: 2pt solid #e94848; border-radius: 1rem; background: #fff0f0;"></canvas>
					  
					  <div class="flex gap-2">
					    <p class="p-2 text-lg font-semibold whitespace-nowrap">Current Track:</p>
					    <span class="p-2 text-lg inline-block w-13 truncate">Track Name Placeholder</span>
					  </div>
					
				  </div>
				</div>
			</div>

			<!-- Transcription Settings -->
			<div class="bg-white rounded-lg shadow-sm px-6 pb-6 space-y-4" data-info="">
				<h2 class="text-xl font-semibold text-gray-900">Transcription Settings</h2>
				<div class="grid grid-cols-2 gap-4">
					<div class="space-y-2">
						<label class="text-sm font-medium text-gray-700">Instrument Type</label>
						<select class="w-full rounded-md border border-gray-200 p-2">
							<option>Piano</option>
							<option>Guitar</option>
							<option>Violin</option>
						</select>
					</div>
					<div class="space-y-2">
						<label class="text-sm font-medium text-gray-700">Time Signature</label>
						<select class="w-full rounded-md border border-gray-200 p-2">
							<option>4/4</option>
							<option>3/4</option>
							<option>6/8</option>
						</select>
					</div>
				</div>
			</div>

			<!-- Analysis Details -->
			<div class="bg-white rounded-lg shadow-sm p-6 space-y-4">
				<h2 class="text-xl font-semibold text-gray-900">Analysis Details</h2>
				<div class="space-y-2">
					<div class="flex justify-between">
						<span class="text-sm text-gray-600">Detected Key:</span>
						<span class="text-sm font-medium">C Major</span>
					</div>
					<div class="flex justify-between">
						<span class="text-sm text-gray-600">Tempo:</span>
						<span class="text-sm font-medium">120 BPM</span>
					</div>
					<div class="flex justify-between">
						<span class="text-sm text-gray-600">Placeholder:</span>
						<span class="text-sm font-medium">Placeholder</span>
					</div>
				</div>
			</div>



			<!-- Modal for Drag-n-Drop Upload -->
		<div id="uploadModal" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 hidden">
			<div class="bg-white w-96 p-6 rounded-lg relative">
				<!-- Close button -->
				<button id="closeModal" class="absolute top-0 right-2 text-gray-600 hover:text-gray-800 text-2xl">&times;</button>
				<!-- Upload Form with Drag-n-Drop Zone -->
				<form id="uploadForm" class="upload-audio" action="" method="POST" enctype="multipart/form-data">
	
					<div class="flex items-center justify-center w-full">
						<label id="modalDropZone" for="modal-dropzone-file"
							class="flex flex-col items-center justify-center w-full h-64 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100">
							<div id="modalDropZoneContent" class="flex flex-col items-center justify-center pt-5 pb-6">
								<svg class="w-8 h-8 mb-4 text-gray-500" aria-hidden="true"
									xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 16">
									<path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
										d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2"/>
								</svg>
								<p class="mb-2 text-sm text-gray-500">
									<span class="font-semibold">Click to upload</span> or drag and drop
								</p>
								<p class="text-xs text-gray-500">Only .wav or .mp3 files accepted</p>
							</div>
							<!-- File input accepts only .wav and .mp3 -->
							<input id="modal-dropzone-file" type="file" class="hidden" accept=".wav,.mp3" />
						</label>
					</div>
					<!-- Hidden Upload Button Revealed on File Drop/Selection -->
					<div id="modalUploadButtonContainer" class="flex items-center justify-center mt-4" style="display: none;">
						<button type="submit" id="modalUploadButton" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
							Upload
						</button>
					</div>
				</form>
			</div>
		</div>

	
		<!-- Inline Scripts -->
		<script src="/JS/modal-script.js"></script>
		<script src="/JS/recorder.js"></script>
		<script src="/JS/upload-audio.js"></script>
		<script src="/css/script.js"></script>
		
		<script>
			
			
			
			$(document).ready(function () {
				function initSynthControls() {

				  if (ABCJS.synth.supportsAudio() && !window.synthControl) {
				    window.synthControl = new ABCJS.synth.SynthController();
				    window.synthControl.load('#audio-controls', null, {
				      displayLoop: true,
				      displayRestart: true,
				      displayPlay: true,
				      displayProgress: true,
				      displayWarp: true,
				    });
				  }
				}
					
				// render sheet music to specific element by id
				function renderSheetMusicById(element_id, abcString) {	

				  if (abcString) {
					
				    // Render sheet music
				    var visualObj = ABCJS.renderAbc(element_id, abcString, {
				      responsive: 'resize',
				      dragging: false,
				    })[0];

				    // Reuse existing audio controls
				    if (ABCJS.synth.supportsAudio() && window.synthControl) {
				      window.synthControl.setTune(visualObj, false);
				    }
				  } else {
				    alert('Transcription failed.');
				  }
				}
				
				let musicSheetList = [];
				
				$('#music-sheet-carousel').each(function(){
					$(this).find('li').each(function(){
						var current = $(this);
						musicSheetList.push({
							sheet_music_title:current.data('musicsheet-title'),
							sheet:current.data('musicsheet-data')
						})
					})
				})
		
				for (var i = 0; i < musicSheetList.length; i++) {
					const currentIdx = i+1;
					renderSheetMusicById('sheet-music-'+currentIdx,musicSheetList[i].sheet)
				} 
				
				if(musicSheetList.length == 0){
					$('#music-sheet-carousel').hide();
				}
				
				$('.sm-sheet-card').on('click', function(){
					initSynthControls()
					renderSheetMusicById('music-sheet',$(this).data('musicsheet-data'))
					$("#music-sheet").removeClass("bg-red-50 border-red-400")
				})
				
			})
			
			$(document).ready(function () {
			  $('.button-wrapper button').hover(
			    function () {
			      // Get tooltip text from data attribute
			      const tooltipText = $(this).data('tooltip');
			      if (!tooltipText) return;
			      // Create tooltip element
			      const $tooltip = $('<div class="custom-tooltip"></div>')
			        .text(tooltipText)
			        .css({
			          position: 'absolute',
			          background: 'rgba(0, 0, 0, 0.7)',
			          color: '#fff',
			          padding: '4px 8px',
			          'border-radius': '3px',
			          'font-size': '12px',
			          'z-index': 1000,
			          display: 'none'
			        });
			      $('body').append($tooltip);
			      // Position tooltip centered above the button
			      const $btn = $(this);
			      const offset = $btn.offset();
			      const left = offset.left + $btn.outerWidth()/2 - $tooltip.outerWidth()/2;
			      const top = offset.top - $tooltip.outerHeight() - 5;
			      $tooltip.css({ left: left, top: top });
			      $tooltip.fadeIn(200);
			      $btn.data('tooltipElement', $tooltip);
			    },
			    function () {
			      // Remove tooltip on mouse leave
			      const $tooltip = $(this).data('tooltipElement');
			      if ($tooltip) {
			        $tooltip.fadeOut(200, function () {
			          $(this).remove();
			        });
			      }
			    }
			  );
			});

		</script>

		<script >
				//Here is javascript to interface MIDI API
				
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
//new comment
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
				
		</script>
</body>
</html>
