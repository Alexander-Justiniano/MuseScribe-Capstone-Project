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
                     <div class="tooltip absolute hidden bg-black text-white text-xs rounded-md px-2 py-1 -top-8 left-1/2 transform -translate-x-1/2 opacity-0 transition-opacity duration-300">
                         Button
                     </div>
                     <button class="p-2 rounded-lg hover:bg-gray-300 abcjs-midi-start abcjs-btn" id="playButton">
                         <i data-feather="play" class="w-5 h-5"></i>
                     </button>
                     <button class="p-2 rounded-lg hover:bg-gray-300 abcjs-midi-stop abcjs-btn" id="stopButton">
                         <i data-feather="square" class="w-5 h-5"></i>
                     </button>
                     <button class="p-2 upload-button rounded-lg hover:bg-gray-300">
                         <i data-feather="upload" class="w-5 h-5"></i>
                     </button>
                     <p class="p-2 text-lg font-semibold whitespace-nowrap">Current Track: </p>
                     <span class="p-2 text-lg inline-block w-13 truncate">Track Name Placeholder</span>
                 </div>

                 <!-- Waveform -->
                 <div class="waveform-placeholder h-32 rounded-lg border border-gray-200"></div>

                 <!-- Timeline -->
                 <div class="space-y-2">
                     <input type="range" class="w-full" value="33">
                     <div class="flex justify-between text-sm text-gray-500">
                         <span>0:00</span>
                         <span>3:45</span>
                     </div>
                 </div>
             </div>

             <!-- Sheet Music -->
             <div class="bg-white rounded-lg shadow-sm p-6 space-y-4">
                 <h2 class="text-xl font-semibold text-gray-900">Sheet Music</h2>

                 <div id="music-sheet" class="sheet-music-placeholder h-64 rounded-lg border border-gray-200">
					<!-- Loading indicator shown while processing requests -->
					<div id="loading" style="display:none;">
					    <p>Processing... Please wait.</p>
					    <img src="https://i.gifer.com/ZZ5H.gif" alt="Loading...">
					</div>
				 </div>
                 <div class="flex gap-2">
                     <button class="p-2 rounded-lg hover:bg-gray-300">
                         <i data-feather="edit-2" class="w-5 h-5"></i>
                     </button>
					
                     <a id="midi-link" download="myfile.midi" href="" class="p-2 rounded-lg hover:bg-gray-300">
                         <i data-feather="download" class="w-5 h-5"></i>
                     </a>
					
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

			<div id="audio"><div class="abcjs-inline-audio">
			<button type="button" class="abcjs-midi-reset abcjs-btn" title="Click to go to beginning." aria-label="Click to go to beginning.">
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 25">
			  <g>
			    <polygon points="5 12.5 24 0 24 25"></polygon>
			    <rect width="3" height="25" x="0" y="0"></rect>
			  </g>
			</svg>
			</button>
			<button type="button" class="abcjs-midi-start abcjs-btn" title="Click to play/pause." aria-label="Click to play/pause.">
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 25" class="abcjs-play-svg">
			    <g>
			    <polygon points="4 0 23 12.5 4 25"></polygon>
			    </g>
			</svg>

			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 25" class="abcjs-pause-svg">
			  <g>
			    <rect width="8.23" height="25"></rect>
			    <rect width="8.23" height="25" x="17"></rect>
			  </g>
			</svg>

			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" class="abcjs-loading-svg">
			    <circle cx="50" cy="50" fill="none" stroke-width="20" r="35" stroke-dasharray="160 55"></circle>
			</svg>
			</button>
			<button type="button" class="abcjs-midi-progress-background" title="Click to change the playback position." aria-label="Click to change the playback position."><span class="abcjs-midi-progress-indicator" style="left: 5.54651px;"></span></button>
			<span class="abcjs-midi-clock">0:00</span>
			<div class="abcjs-css-warning" style="font-size: 12px;color:red;border: 1px solid red;text-align: center;width: 300px;margin-top: 4px;font-weight: bold;border-radius: 4px;">CSS required: load abcjs-audio.css</div></div>
			</div>
			
			<p class="suspend-explanation">Browsers won't allow audio to work unless the audio is started in response to a
					user action. This prevents auto-playing web sites. Therefore, the
					following button is needed to do the initialization:</p>
				<div class="row">
					<div>
						<button class="activate-audio">Activate Audio Context And Play</button>
						<button class="stop-audio" style="display:none;">Stop Audio</button>
						<div class='audio-error' style="display:none;">Audio is not supported in this browser.</div>
					</div>
					<div class="status"></div>
				</div>
			
		    <!-- Inline Scripts -->
		    <script>
		        // Utility function to check if the file extension is .wav or .mp3
		        function isValidAudio(file) {
		            return /\.(wav|mp3)$/i.test(file.name);
		        }

		        // Function to reset drop zone to its default content
		        function resetModalDropZone() {
		            modalDropZone.classList.remove('dragerror');
		            modalDropZoneContent.innerHTML = `
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

		        // Open modal when the icon upload button is clicked
		        const uploadIconButton = document.querySelector('.upload-button');
		        const uploadModal = document.getElementById('uploadModal');
		        const closeModal = document.getElementById('closeModal');

		        uploadIconButton.addEventListener('click', () => {
		            uploadModal.classList.remove('hidden');
		        });

		        // Close modal when the close button is clicked or clicking outside modal content
		        closeModal.addEventListener('click', () => {
		            uploadModal.classList.add('hidden');
		        });

		        uploadModal.addEventListener('click', (e) => {
		            if (e.target === uploadModal) {
		                uploadModal.classList.add('hidden');
		            }
		        });

		        // Modal Drag-and-Drop Functionality
		        const modalDropZone = document.getElementById('modalDropZone');
		        const modalDropZoneContent = document.getElementById('modalDropZoneContent');
		        const modalUploadButtonContainer = document.getElementById('modalUploadButtonContainer');
		        const modalFileInput = document.getElementById('modal-dropzone-file');

		        function handleModalDragOver(e) {
		            e.preventDefault();
		            modalDropZone.classList.add('dragover');
		        }
		        function handleModalDragLeave(e) {
		            e.preventDefault();
		            modalDropZone.classList.remove('dragover');
		        }
		        function handleModalDrop(e) {
		            e.preventDefault();
		            modalDropZone.classList.remove('dragover');
		            const files = e.dataTransfer.files;
		            if (files && files.length > 0) {
		                const file = files[0];
		                if (!isValidAudio(file)) {
		                    // Apply error style and update content
		                    modalDropZone.classList.add('dragerror');
		                    modalDropZoneContent.innerHTML = `
		                        <i data-feather="x" class="w-8 h-8 mb-4 text-red-500"></i>
		                        <p class="mb-2 text-sm text-red-500">
		                            <span class="font-semibold">Error:</span> Invalid file type.
		                        </p>
		                        <p class="text-xs text-red-500">Please upload a .wav or .mp3 file.</p>
		                    `;
		                    // Reset error state after 2 seconds
		                    setTimeout(resetModalDropZone, 2000);
		                    return;
		                }
		                modalDropZoneContent.innerHTML = `
		                    <i data-feather="check" class="w-8 h-8 mb-4 text-green-500"></i>
		                    <p class="mb-2 text-sm text-gray-500">
		                        <span class="font-semibold">File ready:</span> ${file.name}
		                    </p>
		                    <p class="text-xs text-gray-500">File has been dropped.</p>
		                `;
		                modalUploadButtonContainer.style.display = 'flex';
		                if (typeof feather !== 'undefined') {
		                    feather.replace();
		                }
		            }
		        }

		        modalDropZone.addEventListener('dragenter', handleModalDragOver);
		        modalDropZone.addEventListener('dragover', handleModalDragOver);
		        modalDropZone.addEventListener('dragleave', handleModalDragLeave);
		        modalDropZone.addEventListener('drop', handleModalDrop);

		        modalFileInput.addEventListener('change', function () {
		            const files = modalFileInput.files;
		            if (files && files.length > 0) {
		                const file = files[0];
		                if (!isValidAudio(file)) {
		                    modalDropZone.classList.add('dragerror');
		                    modalDropZoneContent.innerHTML = `
		                        <i data-feather="x" class="w-8 h-8 mb-4 text-red-500"></i>
		                        <p class="mb-2 text-sm text-red-500">
		                            <span class="font-semibold">Error:</span> Invalid file type.
		                        </p>
		                        <p class="text-xs text-red-500">Please upload a .wav or .mp3 file.</p>
		                    `;
		                    setTimeout(resetModalDropZone, 2000);
		                    return;
		                }
		                modalDropZoneContent.innerHTML = `
		                    <i data-feather="check" class="w-8 h-8 mb-4 text-green-500"></i>
		                    <p class="mb-2 text-sm text-gray-500">
		                        <span class="font-semibold">File ready:</span> ${file.name}
		                    </p>
		                    <p class="text-xs text-gray-500">File has been selected.</p>
		                `;
		                modalUploadButtonContainer.style.display = 'flex';
		                if (typeof feather !== 'undefined') {
		                    feather.replace();
		                }
		            }
		        });

		        // (Optional) Main page file input update if needed
		        const dropZone = document.getElementById('dropZone');
		        const dropZoneContent = document.getElementById('dropZoneContent');
		        const uploadButtonContainer = document.getElementById('uploadButtonContainer');
		        const fileInput = document.getElementById('dropzone-file');

		        // Ensure the main file input only accepts .wav and .mp3 files
		        fileInput.setAttribute('accept', '.wav,.mp3');

		        function handleDragOver(event) {
		            event.preventDefault();
		            dropZone.classList.add('dragover');
		        }
		        function handleDragLeave(event) {
		            event.preventDefault();
		            dropZone.classList.remove('dragover');
		        }
		        function handleDrop(event) {
		            event.preventDefault();
		            dropZone.classList.remove('dragover');
		            const files = event.dataTransfer.files;
		            if (files && files.length > 0) {
		                const file = files[0];
		                if (!isValidAudio(file)) {
		                    dropZone.classList.add('dragerror');
		                    dropZoneContent.innerHTML = `
		                        <i data-feather="x" class="w-8 h-8 mb-4 text-red-500"></i>
		                        <p class="mb-2 text-sm text-red-500">
		                            <span class="font-semibold">Error:</span> Invalid file type.
		                        </p>
		                        <p class="text-xs text-red-500">Please upload a .wav or .mp3 file.</p>
		                    `;
		                    setTimeout(() => {
		                        dropZone.classList.remove('dragerror');
		                        // Optionally reset dropZoneContent to its default state here.
		                    }, 2000);
		                    return;
		                }
		                dropZoneContent.innerHTML = `
		                    <i data-feather="check" class="w-8 h-8 mb-4 text-green-500"></i>
		                    <p class="mb-2 text-sm text-gray-500">
		                        <span class="font-semibold">File ready:</span> ${file.name}
		                    </p>
		                    <p class="text-xs text-gray-500">File has been dropped.</p>
		                `;
		                uploadButtonContainer.style.display = 'flex';
		                if (typeof feather !== 'undefined') {
		                    feather.replace();
		                }
		            }
		        }

		        dropZone.addEventListener('dragenter', handleDragOver);
		        dropZone.addEventListener('dragover', handleDragOver);
		        dropZone.addEventListener('dragleave', handleDragLeave);
		        dropZone.addEventListener('drop', handleDrop);

		        fileInput.addEventListener('change', function (event) {
		            const files = fileInput.files;
						console.log("file: ",file)
		            if (files && files.length > 0) {
		                const file = files[0];
		                if (!isValidAudio(file)) {
		                    dropZone.classList.add('dragerror');
		                    dropZoneContent.innerHTML = `
		                        <i data-feather="x" class="w-8 h-8 mb-4 text-red-500"></i>
		                        <p class="mb-2 text-sm text-red-500">
		                            <span class="font-semibold">Error:</span> Invalid file type.
		                        </p>
		                        <p class="text-xs text-red-500">Please upload a .wav or .mp3 file.</p>
		                    `;
		                    setTimeout(() => {
		                        dropZone.classList.remove('dragerror');
		                        // Optionally reset dropZoneContent here.
		                    }, 2000);
		                    return;
		                }
		                dropZoneContent.innerHTML = `
		                    <i data-feather="check" class="w-8 h-8 mb-4 text-green-500"></i>
		                    <p class="mb-2 text-sm text-gray-500">
		                        <span class="font-semibold">File ready:</span> ${file.name}
		                    </p>
		                    <p class="text-xs text-gray-500">File has been selected.</p>
		                `;
		                uploadButtonContainer.style.display = 'flex';
		                if (typeof feather !== 'undefined') {
		                    feather.replace();
		                }
		            }
		        });
		    </script>
		    <script src="/css/script.js"></script>
	</body>
</html>