<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | CoolStock Delivery</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; }
    </style>
</head>
<body class="bg-gray-100 min-h-screen">
    <div class="flex">

        <!-- Sidebar (Identical logic to dashboard/history) -->
        <div class="w-64 h-screen bg-orange-700 text-white fixed flex flex-col justify-between">
            <div>
                <div class="p-5 border-b border-orange-600 flex items-center gap-3">
                    <span class="text-2xl">🛵</span>
                    <div>
                        <h2 class="text-lg font-black text-white">CoolStock</h2>
                        <p class="text-xs text-orange-200 uppercase font-black">Staff Hub</p>
                    </div>
                </div>
                <nav class="mt-4 space-y-1 px-3">
                    <a href="${pageContext.request.contextPath}/delivery/dashboard"
                        class="flex items-center gap-3 py-2.5 px-4 rounded-xl font-semibold text-sm ${pageContext.request.requestURI.contains('dashboard') ? 'bg-orange-600' : 'hover:bg-orange-600 transition'}"><span>🏠</span>
                        Active Tasks</a>
                    <a href="${pageContext.request.contextPath}/delivery/history"
                        class="flex items-center gap-3 py-2.5 px-4 rounded-xl font-semibold text-sm ${pageContext.request.requestURI.contains('history') ? 'bg-orange-600' : 'hover:bg-orange-600 transition'}"><span>📜</span>
                        Order History</a>
                    <a href="${pageContext.request.contextPath}/delivery/profile"
                        class="flex items-center gap-3 py-2.5 px-4 rounded-xl font-semibold text-sm ${pageContext.request.requestURI.contains('profile') ? 'bg-orange-600' : 'hover:bg-orange-600 transition'}"><span>👤</span>
                        My Profile</a>
                </nav>
            </div>
            <div class="mb-5 px-4">
                <a href="${pageContext.request.contextPath}/logout"
                    class="block py-3 px-4 bg-red-600 rounded-xl hover:bg-red-700 transition text-center font-bold text-sm text-white">🚪
                    Logout</a>
            </div>
        </div>

        <div class="ml-64 p-8 w-full">
            
            <!-- Header -->
            <div class="bg-gradient-to-r from-orange-600 to-orange-800 text-white p-10 rounded-3xl mb-10 flex justify-between items-center shadow-2xl relative overflow-hidden">
                <div class="relative z-10">
                    <div class="flex items-center gap-4 mb-2">
                        <span class="bg-white/20 px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-widest leading-none">Official Profile</span>
                    </div>
                    <h1 class="text-4xl font-black">${staff.fullName}</h1>
                    <p class="opacity-80 mt-1 uppercase tracking-tighter font-bold">${staff.role} Specialist • Joined <fmt:formatDate value="${staff.joinedDate}" pattern="MMM yyyy"/></p>
                </div>
                <div class="relative z-10 text-right">
                    <div class="text-6xl mb-2 opacity-80">🍦</div>
                </div>
                <!-- Abstract background shapes -->
                <div class="absolute -right-20 -top-20 w-64 h-64 bg-white/10 rounded-full blur-3xl"></div>
                <div class="absolute -left-20 -bottom-20 w-64 h-64 bg-orange-900/20 rounded-full blur-3xl"></div>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                
                <!-- Account Details -->
                <div class="lg:col-span-2 space-y-8">
                    
                    <!-- Stats Grid -->
                    <div class="grid grid-cols-2 gap-6">
                        <div class="bg-white p-8 rounded-[2rem] shadow-xl border border-gray-100 group hover:border-orange-500 transition-all duration-500">
                            <p class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] mb-2">Lifetime Completed</p>
                            <h3 class="text-4xl font-black text-gray-900 leading-none group-hover:text-orange-600 transition-colors">${totalDelivered} <span class="text-lg text-gray-300">Orders</span></h3>
                        </div>
                        <div class="bg-white p-8 rounded-[2rem] shadow-xl border border-gray-100 group hover:border-orange-500 transition-all duration-500">
                            <p class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] mb-2">Awaiting Deposit</p>
                            <h3 class="text-4xl font-black text-gray-900 leading-none group-hover:text-orange-600 transition-colors">${pendingDeposit} <span class="text-lg text-gray-300">Today</span></h3>
                        </div>
                    </div>

                    <!-- Details Card -->
                    <div class="bg-white rounded-[2.5rem] shadow-2xl overflow-hidden border border-gray-100">
                        <div class="bg-gray-50 p-8 border-b border-gray-100 flex items-center justify-between">
                            <h2 class="text-xl font-black text-gray-800 flex items-center gap-3">
                                <span>📋</span> Personal Credentials
                            </h2>
                            <span class="text-[10px] font-black text-orange-600 bg-orange-100 px-3 py-1 rounded-full uppercase tracking-widest">${staff.staffKey}</span>
                        </div>
                        <div class="p-10 space-y-8">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
                                <div>
                                    <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest block mb-1">Full Identity Name</label>
                                    <p class="text-lg font-bold text-gray-800">${staff.fullName}</p>
                                </div>
                                <div>
                                    <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest block mb-1">Contact Terminal</label>
                                    <p class="text-lg font-bold text-gray-800">${staff.phone}</p>
                                </div>
                                <div class="md:col-span-2">
                                    <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest block mb-1">Digital Mailbox</label>
                                    <p class="text-lg font-bold text-gray-800">${staff.email}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Security Panel -->
                <div class="space-y-8">
                    <div class="bg-white rounded-[2.5rem] shadow-2xl overflow-hidden border border-gray-100">
                        <div class="bg-gray-900 p-8 text-white">
                            <h2 class="text-xl font-black flex items-center gap-3">
                                <span>🔒</span> Security Vault
                            </h2>
                            <p class="text-xs text-white/50 mt-1 uppercase font-bold tracking-widest italic">Encrypted Session Data</p>
                        </div>
                        <div class="p-10">
                            
                            <c:if test="${not empty success}">
                                <div class="bg-emerald-100 text-emerald-800 p-4 rounded-xl mb-6 text-xs font-bold border border-emerald-200">
                                    ✅ ${success}
                                </div>
                            </c:if>
                            <c:if test="${not empty error}">
                                <div class="bg-rose-100 text-rose-800 p-4 rounded-xl mb-6 text-xs font-bold border border-rose-200">
                                    ⚠️ ${error}
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/delivery/updatePassword" method="post" class="space-y-6">
                                <div>
                                    <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest block mb-2">New Password</label>
                                    <input type="password" name="newPassword" required
                                        class="w-full px-5 py-4 bg-gray-50 rounded-2xl border border-gray-200 focus:border-orange-500 focus:ring-0 transition font-bold text-sm outline-none"
                                        placeholder="••••••••">
                                </div>
                                <div>
                                    <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest block mb-2">Confirm Rotation</label>
                                    <input type="password" name="confirmPassword" required
                                        class="w-full px-5 py-4 bg-gray-50 rounded-2xl border border-gray-200 focus:border-orange-500 focus:ring-0 transition font-bold text-sm outline-none"
                                        placeholder="••••••••">
                                </div>
                                <button type="submit" 
                                    class="w-full py-5 bg-gray-900 text-white font-black rounded-2xl hover:bg-black transition shadow-xl text-xs tracking-[0.2em] uppercase">
                                    Update Security Key
                                </button>
                                <p class="text-[9px] text-gray-400 text-center font-bold italic tracking-tight">Updating password will affect all active sessions.</p>
                            </form>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</body>
</html>