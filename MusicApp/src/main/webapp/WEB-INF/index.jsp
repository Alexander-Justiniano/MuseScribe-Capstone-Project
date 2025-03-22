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
   
 </style>
 <body class="bg-gray-50 min-h-screen p-8">
     <div class="max-w-6xl mx-auto space-y-6">

         <!-- Header -->
         <div class="flex justify-between items-center">
             <h1 class="text-3xl font-bold text-gray-900">MuseScribe</h1>
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
         <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
             <!-- Audio Input -->
             <div class="bg-white rounded-lg shadow-sm p-6 space-y-4">
                 <h2 class="text-xl font-semibold text-gray-900">Audio Input</h2>

                 <!-- Controls -->
                 <div class="flex gap-2">
                     <!-- TODO: soLook into LIVE transcription -->
                     <button class="p-2 rounded-lg hover:bg-gray-300 relative" id="recordButton">
                         <i data-feather="mic" class="w-5 h-5"></i>
                     </button>
                    <!-- <div class="tooltip absolute hidden bg-black text-white text-xs rounded-md px-2 py-1 -top-8 left-1/2 transform -translate-x-1/2 opacity-0 transition-opacity duration-300">
                         Button
                     </div>
                     <button class="p-2 rounded-lg hover:bg-gray-300 abcjs-midi-start abcjs-btn" id="playButton">
                         <i data-feather="play" class="w-5 h-5"></i>
                     </button>
                     <button class="p-2 rounded-lg hover:bg-gray-300 abcjs-midi-stop abcjs-btn" id="stopButton">
                         <i data-feather="square" class="w-5 h-5"></i>
                     </button>-->
                     <button class="p-2 upload-button rounded-lg hover:bg-gray-300">
                         <i data-feather="upload" class="w-5 h-5"></i>
                     </button>
                     <p class="p-2 text-lg font-semibold whitespace-nowrap">Current Track: </p>
                     <span class="p-2 text-lg inline-block w-13 truncate">Track Name Placeholder</span>
                 </div>

                 <!-- Waveform
                 <div class="waveform-placeholder h-32 rounded-lg border border-gray-200"></div> -->

				 <div id="audio-controls"></div>
                 <!-- Timeline/Controls -->

             </div>

             <!-- Sheet Music -->
             <div class="bg-white rounded-lg shadow-sm p-6 space-y-4">
                 <h2 class="text-xl font-semibold text-gray-900">Sheet Music</h2>

                 <div id="music-sheet" class="sheet-music-placeholder h-64 rounded-lg border border-gray-200 flex justify-center">
					<!-- Loading indicator shown while processing requests -->
					<div id="loading" class="flex items-center" style="display:none;">
					    <p>Processing... Please wait.</p>
					    <img src="https://i.gifer.com/ZZ5H.gif" alt="Loading..." class="w-6 ml-2">
					</div>
				 </div>
                 <div class="flex gap-2">
                     <button class="p-2 rounded-lg hover:bg-gray-300">
                         <i data-feather="edit-2" class="w-5 h-5"></i>
                     </button>
					
                     <button id="midi-link" class="p-2 rounded-lg hover:bg-gray-300">
                         <i data-feather="download" class="w-5 h-5"></i>
                     </button>
					
                 </div>
             </div>

             <!-- Transcription Settings -->
             <div class="bg-white rounded-lg shadow-sm p-6 space-y-4" data-info="">
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
		    <script>
				
				$(document).ready(function() {
				  // Default HTML templates
				  function defaultModalHTML() {
				    return `
				      <svg class="w-8 h-8 mb-4 text-gray-500" aria-hidden="true"
				           xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 16">
				           <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
				                 d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2"/>
				      </svg>
				      <p class="mb-2 text-sm text-gray-500">
				         <span class="font-semibold">Click to upload</span> or drag and drop
				      </p>
				      <p class="text-xs text-gray-500">Only .wav or .mp3 files accepted</p>
				    `;
				  }

				  function getErrorHTML() {
				    return `
				      <i data-feather="x" class="w-8 h-8 mb-4 text-red-500"></i>
				      <p class="mb-2 text-sm text-red-500">
				         <span class="font-semibold">Error:</span> Invalid file type.
				      </p>
				      <p class="text-xs text-red-500">Please upload a .wav or .mp3 file.</p>
				    `;
				  }

				  function getSuccessHTML(fileName, actionMsg) {
				    return `
				      <i data-feather="check" class="w-8 h-8 mb-4 text-green-500"></i>
				      <p class="mb-2 text-sm text-gray-500">
				         <span class="font-semibold">File ready:</span> ${fileName}
				      </p>
				      <p class="text-xs text-gray-500">${actionMsg}</p>
				    `;
				  }

				  // Resets the modal drop zone to its default state
				  function resetModalDropZone() {
				    $('#modal-dropzone-file').val('');
				    $('#modalDropZone').removeClass('dragerror dragover');
				    $('#modalDropZoneContent').html(defaultModalHTML());
				    $('#modalUploadButtonContainer').css('display', 'none');
				  }

				  // Generic file handler for drop and change events
				  function updateDropZone($zone, $content, $button, file, successMsg, errorResetCb) {
				    if (!/\.(wav|mp3)$/i.test(file.name)) {
				      $zone.addClass('dragerror');
				      $content.html(getErrorHTML());
				      setTimeout(errorResetCb, 2000);
				      return false;
				    }
				    $content.html(getSuccessHTML(file.name, successMsg));
				    $button.css('display', 'flex');
				    if (typeof feather !== 'undefined') { feather.replace(); }
				    return true;
				  }

				  // Helper to add drag events
				  function addDragEvents($zone) {
				    $zone.on('dragenter dragover', function(e) {
				      e.preventDefault();
				      $(this).addClass('dragover');
				    }).on('dragleave', function(e) {
				      e.preventDefault();
				      $(this).removeClass('dragover');
				    });
				  }

				  // Modal open/close events with reset on close
				  $('.upload-button').on('click', () => $('#uploadModal').removeClass('hidden'));
				  
				  $('#closeModal').on('click', function() {
				    $('#uploadModal').addClass('hidden');
				    resetModalDropZone();
				  });
				  
				  $('#uploadModal').on('click', function(e) {
				    if (e.target.id === 'uploadModal') {
				      $(this).addClass('hidden');
				      resetModalDropZone();
				    }
				  });

				  // Modal drop zone events
				  addDragEvents($('#modalDropZone'));
				  
				  $('#modalDropZone').on('drop', function(e) {
				    e.preventDefault();
				    $(this).removeClass('dragover');
				    var files = e.originalEvent.dataTransfer.files;
				    if (files.length) {
				      updateDropZone($(this), $('#modalDropZoneContent'), $('#modalUploadButtonContainer'),
				                     files[0], 'File has been dropped.', resetModalDropZone);
				    }
				  });
				  
				  $('#modal-dropzone-file').on('change', function() {
				    var files = this.files;
				    if (files.length) {
				      updateDropZone($('#modalDropZone'), $('#modalDropZoneContent'), $('#modalUploadButtonContainer'),
				                     files[0], 'File has been selected.', resetModalDropZone);
				    }
				  });

				  // Main drop zone events
				  $('#dropzone-file').attr('accept', '.wav,.mp3');
				  addDragEvents($('#dropZone'));
				  
				  $('#dropZone').on('drop', function(e) {
				    e.preventDefault();
				    $(this).removeClass('dragover');
				    var files = e.originalEvent.dataTransfer.files;
				    if (files.length) {
				      updateDropZone($(this), $('#dropZoneContent'), $('#uploadButtonContainer'),
				                     files[0], 'File has been dropped.', () => $(this).removeClass('dragerror'));
				    }
				  });
				  
				  $('#dropzone-file').on('change', function() {
				    var files = this.files;
				    if (files.length) {
				      updateDropZone($('#dropZone'), $('#dropZoneContent'), $('#uploadButtonContainer'),
				                     files[0], 'File has been selected.', () => $('#dropZone').removeClass('dragerror'));
				    }
				  });
				});


		    </script>
		    <script src="/css/script.js"></script>
	</body>
</html>