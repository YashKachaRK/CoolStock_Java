<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Login | CoolStock</title>
            <script src="https://cdn.tailwindcss.com"></script>
            <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap"
                rel="stylesheet">
            <style>
                body {
                    font-family: 'Outfit', sans-serif;
                }
            </style>
        </head>

        <body class="bg-gradient-to-br from-purple-600 to-pink-500 flex items-center justify-center min-h-screen px-4">

            <div class="bg-white p-8 rounded-3xl shadow-2xl w-full max-w-md">

                <div class="text-center mb-7">
                    <div class="text-5xl mb-2">🍦</div>
                    <h1 class="text-3xl font-black text-gray-800">CoolStock</h1>
                    <p class="text-gray-400 text-sm mt-1">Ice Cream Wholesale Management</p>
                </div>

                <!-- Error message from flash attribute -->
                <c:if test="${not empty loginError}">
                    <div class="bg-red-100 text-red-600 p-3 rounded-xl mb-5 text-center text-sm font-semibold">
                        ${loginError}
                    </div>
                </c:if>

                <!-- Login form → POST /login (handled by Spring Controller) -->
                <form action="${pageContext.request.contextPath}/login" method="post" class="space-y-4">

                    <div>
                        <label class="block text-sm font-semibold text-gray-600 mb-1">Username</label>
                        <input type="text" name="username" required placeholder="Enter username"
                            class="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:border-purple-400 outline-none transition">
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-gray-600 mb-1">Password</label>
                        <input type="password" name="password" required placeholder="Enter password"
                            class="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:border-purple-400 outline-none transition">
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-gray-600 mb-1">Select Role</label>
                        <select name="role"
                            class="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:border-purple-400 outline-none bg-white">
                            <option value="admin">⚙️ Admin</option>
                            <option value="manager">📊 Manager</option>
                            <option value="delivery">🛵 Delivery Boy</option>
                            <option value="cashier">💳 Cashier</option>
                            <option value="customer">🏪 Customer (Shop Owner)</option>
                        </select>
                    </div>

                    <button type="submit"
                        class="w-full bg-gradient-to-r from-purple-600 to-pink-500 text-white py-3 rounded-xl font-bold hover:opacity-90 transition shadow-lg">
                        🔐 Login
                    </button>
                </form>

                <div class="mt-4 text-center">
                    <a href="${pageContext.request.contextPath}/forgot-password"
                        class="text-pink-500 text-sm hover:underline font-semibold">
                        Forgot Password?
                    </a>
                </div>

                <!-- Success message from URL param -->
                <c:if test="${not empty param.msg}">
                    <div class="mt-4 bg-green-100 text-green-600 p-3 rounded-xl text-center text-sm font-semibold">
                        ${param.msg}
                    </div>
                </c:if>

                <!-- Demo credentials hint -->
                <div class="mt-6 bg-gray-50 rounded-xl p-4 text-xs text-gray-400 space-y-1">
                    <p class="font-semibold text-gray-500 mb-2">🧪 Demo Credentials (all passwords: 1234)</p>
                    <p>⚙️ admin &nbsp;|&nbsp; 📊 manager &nbsp;|&nbsp; 🛵 delivery</p>
                    <p>💳 cashier &nbsp;|&nbsp; 🏪 customer</p>
                </div>

                <div class="mt-4 text-center">
                    <a href="${pageContext.request.contextPath}/"
                        class="text-purple-500 text-sm hover:underline font-semibold">
                        ← Back to Home
                    </a>
                </div>

            </div>
        </body>

        </html>