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
		<div class="grid grid-cols-1  gap-6">
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
				
				<div class=" sticky bottom-0 rounded pb-4 "> 
					<div class="bg-gray-50 shadow rounded px-3 pt-3 "> 
					<!-- ABC.js Audio Controls -->
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
					    <button id="recordButton" class="p-2 border rounded-lg hover:bg-red-200 relative" data-tooltip="Record">
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
<script>
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
	
		<!-- Inline Scripts -->
		<script src="/JS/modal-script.js"></script>
		<script src="/JS/recorder.js"></script>
		<script src="/JS/upload-audio.js"></script>
		<script src="/css/script.js"></script>
</body>
</html>