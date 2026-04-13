<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>My Profile | CoolStock</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; }
    </style>
</head>

<body class="bg-gray-100 min-h-screen">

    <!-- Customer Nav -->
    <nav class="bg-white shadow-sm sticky top-0 z-40 px-6 py-3 flex justify-between items-center">
        <div class="flex items-center gap-2">
            <span class="text-3xl">🍦</span>
            <div>
                <span class="text-xl font-black text-gray-800">CoolStock</span>
                <span class="text-xs text-gray-400 ml-2 uppercase tracking-widest font-bold">Customer Portal</span>
            </div>
        </div>
        <div class="flex gap-6 text-sm font-bold uppercase tracking-wider">
            <a href="orders" class="text-gray-400 hover:text-purple-600 transition">📦 Place Order</a>
            <a href="track" class="text-gray-400 hover:text-purple-600 transition">📍 Track Orders</a>
            <a href="profile" class="text-purple-600 border-b-2 border-purple-600 pb-1">👤 My Profile</a>
        </div>
        <a href="${pageContext.request.contextPath}/logout"
            class="bg-red-50 text-red-600 px-5 py-2.5 rounded-2xl font-black text-xs hover:bg-red-100 transition uppercase tracking-widest border border-red-100">
            🚪 Logout
        </a>
    </nav>

    <div class="max-w-5xl mx-auto px-6 py-10">
        
        <div class="bg-gradient-to-r from-purple-600 to-pink-500 text-white p-10 rounded-[2.5rem] mb-10 shadow-2xl flex justify-between items-center">
            <div>
                <h1 class="text-4xl font-black tracking-tighter">👤 Business Profile</h1>
                <p class="opacity-90 mt-2 font-medium italic">Manage your shop credentials and account security.</p>
            </div>
            <div class="text-right">
                <p class="text-[10px] font-black uppercase tracking-[0.3em] opacity-60">Customer Key</p>
                <p class="text-2xl font-black font-mono tracking-tighter">${customer.customerKey}</p>
            </div>
        </div>

        <div class="grid grid-cols-3 gap-10">
            
            <!-- Sidebar: Shop Identity -->
            <div class="space-y-6">
                <div class="bg-white rounded-[2.5rem] shadow-xl p-8 text-center border border-gray-100">
                    <div class="w-32 h-32 bg-purple-50 rounded-full mx-auto mb-6 flex items-center justify-center text-5xl border-4 border-white shadow-lg">
                        🏪
                    </div>
                    <h2 class="text-2xl font-black text-gray-900 tracking-tight leading-tight mb-1">${customer.shopName}</h2>
                    <p class="text-purple-500 font-bold text-xs uppercase tracking-widest mb-6">${customer.ownerName}</p>
                    
                    <div class="space-y-4 py-6 border-y border-gray-50 text-left">
                        <div class="flex items-center gap-3 text-sm">
                            <span class="text-purple-400">📞</span>
                            <span class="font-bold text-gray-700 font-mono">${customer.phone}</span>
                        </div>
                        <div class="flex items-center gap-3 text-sm">
                            <span class="text-purple-400">📧</span>
                            <span class="font-medium text-gray-600 truncate">${customer.email}</span>
                        </div>
                        <div class="flex items-center gap-3 text-sm">
                            <span class="text-purple-400">📍</span>
                            <span class="font-medium text-gray-600">${customer.city}, ${customer.area}</span>
                        </div>
                    </div>
                    
                    <p class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mt-6 italic">Partner since <fmt:formatDate value="${customer.joinedDate}" pattern="MMM yyyy" /></p>
                </div>

                <!-- Stats -->
                <div class="bg-gray-900 rounded-[2rem] p-8 shadow-2xl text-white">
                    <p class="text-[10px] text-purple-400 font-black uppercase tracking-widest mb-4">Lifetime Activity</p>
                    <div class="space-y-6">
                        <div>
                            <p class="text-gray-400 text-[10px] font-bold uppercase mb-1">Total Procurement</p>
                            <p class="text-3xl font-black font-mono tracking-tighter">₹${customer.totalSpend}</p>
                        </div>
                        <div class="flex items-center gap-2">
                             <div class="h-2 flex-1 bg-gray-800 rounded-full overflow-hidden">
                                 <div class="h-full bg-gradient-to-r from-purple-500 to-pink-500 w-[65%]"></div>
                             </div>
                             <span class="text-[10px] font-black">LOYALTY 65%</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Content: Security & Updates -->
            <div class="col-span-2 space-y-8">
                
                <!-- Account Security -->
                <div class="bg-white rounded-[2.5rem] shadow-xl p-10 border border-gray-100">
                    <h3 class="text-2xl font-black text-gray-900 mb-8 tracking-tighter flex items-center gap-3">
                        <span class="p-2 bg-orange-50 rounded-xl text-lg">🛡️</span> 
                        Update Shop Security
                    </h3>

                    <c:if test="${not empty passSuccess}">
                        <div class="mb-8 bg-green-50 border border-green-100 p-4 rounded-2xl flex items-center gap-3 text-green-700 text-sm font-bold">
                            <span>✅</span> ${passSuccess}
                        </div>
                    </c:if>
                    <c:if test="${not empty passError}">
                        <div class="mb-8 bg-red-50 border border-red-100 p-4 rounded-2xl flex items-center gap-3 text-red-700 text-sm font-bold">
                            <span>⚠️</span> ${passError}
                        </div>
                    </c:if>

                    <form action="updatePassword" method="POST" class="space-y-6">
                        <div class="grid grid-cols-2 gap-6">
                            <div class="space-y-2">
                                <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest ml-1">New Password</label>
                                <input type="password" name="newPassword" required 
                                    placeholder="••••••••"
                                    class="w-full bg-gray-50 border-2 border-gray-50 rounded-2xl px-5 py-4 text-sm font-bold outline-none focus:bg-white focus:border-purple-400 transition-all">
                            </div>
                            <div class="space-y-2">
                                <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest ml-1">Confirm New Password</label>
                                <input type="password" name="confirmPassword" required 
                                    placeholder="••••••••"
                                    class="w-full bg-gray-50 border-2 border-gray-50 rounded-2xl px-5 py-4 text-sm font-bold outline-none focus:bg-white focus:border-purple-400 transition-all">
                            </div>
                        </div>
                        
                        <div class="bg-blue-50/50 rounded-2xl p-5 border border-blue-100/50">
                            <p class="text-xs font-semibold text-blue-700 leading-relaxed italic">
                                Note: You don't need your current password to update it. Since you're already logged in, we trust you know your shop's credentials. Choose a strong, memorable password.
                            </p>
                        </div>

                        <button type="submit" 
                            class="w-full py-5 bg-gray-900 text-white font-black rounded-2xl hover:bg-black transition-all shadow-xl shadow-gray-200 text-sm tracking-widest uppercase">
                            UPDATE ACCESS PRIVILEGES
                        </button>
                    </form>
                </div>

                <!-- Contact Info Visibility (Read-only as per request focus) -->
                <div class="bg-white rounded-[2.5rem] shadow-xl p-10 border border-gray-100">
                    <h3 class="text-2xl font-black text-gray-900 mb-8 tracking-tighter flex items-center gap-3">
                        <span class="p-2 bg-blue-50 rounded-xl text-lg">📄</span> 
                        Business Profile Data
                    </h3>
                    <div class="grid grid-cols-2 gap-8">
                        <div>
                            <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest mb-1">Official Shop Name</p>
                            <p class="text-sm font-bold text-gray-700">${customer.shopName}</p>
                        </div>
                        <div>
                            <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest mb-1">Tax/Customer Key</p>
                            <p class="text-sm font-bold text-gray-700">${customer.customerKey}</p>
                        </div>
                        <div class="col-span-2">
                            <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest mb-1">Registered Address</p>
                            <p class="text-sm font-bold text-gray-700">${customer.area}, ${customer.city}</p>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <div class="mt-16 text-center text-gray-400 text-[10px] font-black uppercase tracking-[0.4em]">
            CoolStock • Authorized Retailer Portal • Security Level 4
        </div>
    </div>

</body>
</html>