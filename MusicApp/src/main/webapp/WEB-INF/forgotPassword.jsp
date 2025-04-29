<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Password Support</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <!-- Tailwind CSS -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">
  <div class="bg-white p-8 rounded-lg shadow-lg text-center max-w-sm">
    <!-- Lock Icon -->
    <svg xmlns="http://www.w3.org/2000/svg"
         class="mx-auto mb-4 w-16 h-16 text-gray-400"
         fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="M12 11c1.657 0 3-1.343 3-3V5a3 3 0 10-6 0v3c0 1.657 1.343 3 3 3z"/>
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="M5 11h14a2 2 0 012 2v7a2 2 0 01-2 2H5a2 2 0 01-2-2v-7a2 2 0 012-2z"/>
    </svg>

    <!-- Main Message -->
    <h1 class="text-2xl font-bold mb-2">Password Support Coming Soon!!!</h1>
    <p class="text-gray-600 mb-6">
      We’re working hard to bring you this feature. Please check back later.
    </p>

    <!-- Return Button -->
    <a href="${pageContext.request.contextPath}/login"
       class="inline-block px-6 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 transition">
      Return to Login
    </a>
  </div>
</body>
</html>