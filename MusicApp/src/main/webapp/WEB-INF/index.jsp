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
	width: 130px !important;
	height: 152px;
	justify-content: center;
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
}

</style>

  <body class="bg-gray-50 min-h-screen py-8 px-3">
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
              <button class="recordButton bg-red-500 border-2 border-red-400 rounded p-3 px-4 text-white text-4xl sm:text-xl">
                Record
              </button>
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
              <div id="notebook-carousel" class="border rounded p-4">
                <h3 class="text-center text-lg">
                  Your Notebooks
                </h3>
                <ul>
				<!--Render Notebooks-->
                  <c:forEach var="nb" items="${notebooks}">
                    <li class="notebook-sheet-card sheet-card uppercase rounded bg-gray-200 items-center font-bold flex-col"
                    data-notebook-id="${nb.id}" data-notebook-title="${nb.title}">
                      ${nb.title}
                      <span class="text-sm underline font-normal opacity-50">
                        Open Book
                      </span>
                    </li>
                  </c:forEach>
                </ul>
              </div>
            </c:if>
            <div id="music-sheet-carousel" class="border rounded" style="display:none;">
              <div class="bg-gray-200 flex p-1 text-center">
                <button id='backToNotebooks' class="text-underline rounded bg-white mr-4 px-2 hover:bg-gray-100 transition-all duration-1500">
                  Back
                </button>
                <h3 id="current-notebook-title" class="text-center text-lg "></h3>
              </div>
              <div class="p-4">
				<!--Render Music Sheets-->
                <ul class="gap-4 grid grid-cols-7"></ul>
              </div>
            </div>
          </div>
          <!-- ABC.js Audio Controls -->
          <div class=" sticky bottom-0 rounded pb-4 ">
            <div class="bg-gray-50 shadow rounded px-3 pt-3 ">
              <div id="audio-controls"></div>
              <!--Buttons-->
              <div class="flex flex-col py-3 ">
                <div class="button-wrapper flex gap-2 justify-between sm:justify-start">
                  <!-- Edit -->
                  <button class="p-2 border rounded-lg hover:bg-yellow-200" data-tooltip="Edit">
                    <i data-feather="edit-2" class="sm:w-5 sm:h-5"></i>
                  </button>
                  <!-- Download -->
                  <button id="midi-link" class="p-2 border rounded-lg hover:bg-purple-200"
                  data-tooltip="Download">
                    <i data-feather="download" class="sm:w-5 sm:h-5"></i>
                  </button>
                  <!-- Save -->
                  <button id="music-save" class="p-2 border rounded-lg hover:bg-blue-200"
                  data-tooltip="Save">
                    <i data-feather="save" class="sm:w-5 sm:h-5"></i>
                  </button>
                  <!-- Record -->
                  <button id="recordButton" class="p-2 recordButton border rounded-lg hover:bg-red-200 relative"
                  data-tooltip="Record">
                    <i data-feather="mic" class="sm:w-5 sm:h-5"></i>
                  </button>
                  <!-- Upload -->
                  <button id="upload-audio" class="p-2 border upload-button rounded-lg hover:bg-green-200"
                  data-tooltip="Upload Audio (.mp3 | .wav)">
                    <i data-feather="upload" class="sm:w-5 sm:h-5"></i>
                  </button>
                </div>
                  <!-- Recording Controls: Initially hidden -->
                  <div id="recording-controls" class="inline-flex gap-2 my-2" style="display: none;">
                    <button id="stop-recording" class="p-2 rounded-lg border hover:bg-gray-200">
                      Stop
                    </button>
                    <button id="reset-recording" class="p-2 rounded-lg border hover:bg-gray-200">
                      Reset
                    </button>
                    <button id="submit-recording" class="p-2 rounded-lg border hover:bg-gray-200"
                    style="display: none;">
                      Submit
                    </button>
                  </div>
                <!-- Waveform canvas -->
                <canvas id="waveform" style="display:none;height: 100px; border: 2pt solid #e94848; border-radius: 1rem; background: #fff0f0;">
                </canvas>
              </div>
            </div>
          </div>
		  <!-- Header Editor Section -->
		   <div class="bg-white p-4 rounded shadow">
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
		           <option>1/1</option>
				   <option>1/2</option>
				   <option>1/4</option>
				   <option>1/8</option>
				   <option>1/16</option>
		         </select>
		       </label>
		       <label>Tempo:
		         <input type="number" class="border p-1 w-full rounded" id="abc-tempo" min="30" max="300" step="1" value="150" placeholder="e.g. 150">
		       </label>
		       <label>Key:
		         <select class="border p-1 w-full rounded" id="abc-key">
					<option disabled selected>Choose an option</option>
		           <option>C</option>
				   <option>G</option>
				   <option>D</option>
				   <option>A</option>
				   <option>E</option>
				   <option>B</option>
				   <option>F#</option>
				   <option>C#</option>
		           <option>F</option>
				   <option>Bb</option>
				   <option>Eb</option>
				   <option>Ab</option>
				   <option>Db</option>
				   <option>Gb</option>
				   <option>Cb</option>
		         </select>
		       </label>
		     </div>
		     <button id="updateAbcHeader" class="mt-4 bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Update</button>
		   </div>
          <!-- Modal for Drag-n-Drop Upload -->
          <div id="uploadModal" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 hidden">
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
                      <svg class="w-8 h-8 mb-4 text-gray-500" aria-hidden="true" xmlns="http://www.w3.org/2000/svg"
                      fill="none" viewBox="0 0 20 16">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                        stroke-width="2" d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2"
                        />
                      </svg>
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
                    <input id="modal-dropzone-file" type="file" class="hidden" accept=".wav,.mp3"
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
          </div>
        </div>
      </div>
    </div>
    <!-- Inline Scripts -->
    <script src="/JS/modal-script.js"> </script>
    <script src="/JS/recorder.js"></script>
    <script src="/JS/upload-audio.js"></script>
    <script src="/CSS/script.js"></script>

    <script>
      $(document).ready(function() {
		
		function extractNoteSection(abc) {
	        const lines = abc.split('\n');
	        const noteLines = [];
	        let inNotes = false;
	        for (let line of lines) {
	          if (!inNotes && /^[A-Ga-gzZ|:\s]/.test(line)) {
	            inNotes = true;
	          }
	          if (inNotes) noteLines.push(line);
	        }
	        return noteLines.join('\n');
	      }

	      function extractHeaderValue(abc, targetKey) {
			let foundValue = null;
			abc.split(/\r?\n/).forEach(line => {
			  const match = line.match(/^\s*([A-Za-z][A-Za-z0-9]*)\:(.*?)\s*$/);
			  if (match) {
			    const key = match[1];
			    const value = match[2];
				if(targetKey == key){		
					foundValue = value;
				}
			  }
			});
			
			return foundValue;
	      }

		  function populateInputsFromAbc(abc) {

		    $('#abc-title').val(extractHeaderValue(abc, 'T'));
		    $('#abc-composer').val(extractHeaderValue(abc, 'C'));
		    $('#abc-transcriber').val(extractHeaderValue(abc, 'Z'));

		    const meterVal = extractHeaderValue(abc, 'M');
		    if ($("#abc-meter option[value='"+meterVal+"']").length) {
		      $('#abc-meter').val(meterVal);
		    } 

		    const lengthVal = extractHeaderValue(abc, 'L');
			
		    if ($("#abc-length option[value='"+lengthVal+"']").length) {
		      $('#abc-length').val(lengthVal);
		    } else {
		      $('#abc-length').val("1/8");
		    }

		    const tempoVal = extractHeaderValue(abc, 'Q');
		    if (tempoVal) {
		      $('#abc-tempo').val(tempoVal);
		    }

		    const keyVal = extractHeaderValue(abc, 'K');
		    if ($("#abc-key option[value='"+keyVal+"']").length) {
		      $('#abc-key').val(keyVal);
		    } 
		  }

		  
		  function buildAbcFromInputs(noteSection) {

			const headers = [
			  "T:" + $("#abc-title").val(),
			  $("#abc-composer").val() ? "C:" + $("#abc-composer").val() : "",
			  $("#abc-transcriber").val() ? "Z:" + $("#abc-transcriber").val() : "",
			  $("#abc-meter").val() ? "M:" + $("#abc-meter").val() : "4/4",
			  $("#abc-length").val() && "L:" + $("#abc-length").val(),
			  $("#abc-tempo").val() ? "Q:" + $("#abc-tempo").val() : "150",
			  $("#abc-key").val() && "K:" + $("#abc-key").val()
			].filter(Boolean);

		    return [...headers, noteSection].join('\n');
		  }
		
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
			initSynthControls(); 

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

        // 1. load sheets via AJAX
        $('#notebook-carousel').on('click', '.notebook-sheet-card',function() {
          const notebookId = $(this).data('notebook-id');
          const notebookTitle = $(this).data('notebook-title');

          $('#notebook-carousel').hide();
          $('#music-sheet-carousel').show();
          $('#current-notebook-title').text(notebookTitle);
          $('#loading').show();
          $('#music-sheet-carousel ul').empty();

          $.getJSON("/api/notebooks/" + notebookId + "/sheets").done(sheets => {
            $('#loading').hide();
            if (!sheets.length) {
              $('#music-sheet-carousel ul').append('<li>No sheets found.</li>');
              return;
            }
            sheets.forEach((sheet, idx) => {
              const number = idx + 1;
			  $('#music-sheet-carousel ul').append("<li id='sheet-music-" + number + "' class='sm-sheet-card rounded' data-musicsheet-data='" + sheet.abcNotation + "' data-musicsheet-title='" + sheet.title + "'>" + sheet.title + "</li>");
            });

            let musicSheetList = [];

            $("#music-sheet-carousel").find('li').each(function() {
              var current = $(this);
              musicSheetList.push({
                sheet_music_title: current.data('musicsheet-title'),
                sheet: current.data('musicsheet-data')
              })
            })

            for (var i = 0; i < musicSheetList.length; i++) {
              const currentIdx = i + 1;
              renderSheetMusicById('sheet-music-' + currentIdx, musicSheetList[i].sheet)
            }

          }).fail(err => {
            $('#loading').hide();
            alert('Failed to load sheets');
          });

        });

		let extractedNoted = null;
		
        // 2. render ABC.js notation
        $('#music-sheet-carousel').on('click', '.sm-sheet-card', function() {
          $('#uploadShortcutWrapper').hide();
          const abc = $(this).data('musicsheet-data') || '';
		  extractedNoted = extractNoteSection(abc)
		  console.log(abc)
		  populateInputsFromAbc(abc);
		  renderSheetMusicById('music-sheet', $(this).data('musicsheet-data')); 
		  $("#music-sheet").removeClass("bg-red-50 border-red-400");
        });

		// update sheet music with new settings when update button is clicked
		$('#updateAbcHeader').click(function () {
		  const updatedAbc = buildAbcFromInputs(extractedNoted);
		  console.log("updatedMusicSheet : ",updatedAbc)
		  renderSheetMusicById('music-sheet', updatedAbc); 
		});
		
		// Logic to hide sheet music and display notebooks when back button is clicked
        $('#backToNotebooks').on('click', function() {
          $('#notebook-carousel').show();
          $('#uploadShortcutWrapper').show();
          $('#music-sheet-carousel').hide();
        })

		// music action buttons tooltip (edit, download, save, record, upload)
        $('.button-wrapper button').hover(function() {
          // Get tooltip text from data attribute
          const tooltipText = $(this).data('tooltip');
          if (!tooltipText) return;
          // Create tooltip element
          const $tooltip = $('<div class="custom-tooltip"></div>').text(tooltipText).css({
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
          const left = offset.left + $btn.outerWidth() / 2 - $tooltip.outerWidth() / 2;
          const top = offset.top - $tooltip.outerHeight() - 5;
          $tooltip.css({
            left: left,
            top: top
          });
          $tooltip.fadeIn(200);
          $btn.data('tooltipElement', $tooltip);
        },
        function() {
          // Remove tooltip on mouse leave
          const $tooltip = $(this).data('tooltipElement');
          if ($tooltip) {
            $tooltip.fadeOut(200,
            function() {
              $(this).remove();
            });
          }
        });
      });
    </script>
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