<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>My Profile</title>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css" rel="stylesheet">
  <link href="/CSS/style.css" rel="stylesheet">
</head>
<body class="bg-gray-50 min-h-screen py-8 px-3">
  <div class="max-w-md mx-auto bg-white rounded shadow p-6">
    <!-- Profile heading -->
    <h1 class="text-2xl font-bold mb-4">My Profile</h1>

    <!-- Always show default profile picture -->
    <div class="mb-4 text-center">
      <img class="w-32 h-32 rounded-full mx-auto border"
           src="/IMGS/default-user-pic.svg"
           alt="Default User Picture"/>
    </div>

    <!-- User info -->
    <div class="mb-4">
      <p><strong>Name:</strong> ${user.name}</p>
      <p><strong>Email:</strong> ${user.email}</p>
    </div>

    <!-- Back to dashboard -->
    <div class="text-center">
      <a href="${pageContext.request.contextPath}/dashboard/${user.id}"
         class="inline-block bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">
        Return to Dashboard
      </a>
    </div>
  </div>
</body>
</html>