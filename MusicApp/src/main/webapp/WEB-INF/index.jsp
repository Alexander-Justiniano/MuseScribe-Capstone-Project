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
    <link href="/css/style.css" rel= "stylesheet">
	<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.28.0/feather.min.js"></script>
</head>
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
                    <button class="p-2 rounded-lg hover:bg-gray-300" id="playButton">
                        <i data-feather="play" class="w-5 h-5"></i>
                    </button>
                    <button class="p-2 rounded-lg hover:bg-gray-300">
                        <i data-feather="square" class="w-5 h-5"></i>
                    </button>
                    <button class="p-2 rounded-lg hover:bg-gray-300">
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
                <div class="sheet-music-placeholder h-64 rounded-lg border border-gray-200"></div>
                <div class="flex gap-2">
                    <button class="p-2 rounded-lg hover:bg-gray-300">
                        <i data-feather="edit-2" class="w-5 h-5"></i>
                    </button>
                    <button class="p-2 rounded-lg hover:bg-gray-300">
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
        </div>
    </div>
    <!-- TODO: Add Attribution for the google icons if you intend to add them: https://icons8.com/icons/set/google -->
    <script src="/css/script.js"></script>
</body>
</html>