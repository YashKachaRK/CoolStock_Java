<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Manage Staff | CoolStock Admin</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Outfit', sans-serif;
            }
        </style>
    </head>

    <body class="bg-gray-100 min-h-screen">
        <div class="flex">
            <%@ include file="sidebar.jsp" %>
                <div class="ml-64 p-8 w-full">

                    <div
                        class="bg-gradient-to-r from-slate-800 to-gray-700 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
                        <div>
                            <h1 class="text-3xl font-black">&#x1F465; Manage Staff</h1>
                            <p class="opacity-70 mt-1">All Managers, Cashiers and Delivery Boys in the system</p>
                        </div>
                        <div class="flex gap-4 items-center">
                            <select id="roleFilter" onchange="filterStaff()"
                                class="bg-white/20 border border-white/30 text-white rounded-xl px-4 py-2 text-sm font-semibold outline-none w-40">
                                <option value="all" class="text-gray-800">All Roles</option>
                                <option value="Manager" class="text-gray-800">Manager</option>
                                <option value="Cashier" class="text-gray-800">Cashier</option>
                                <option value="Delivery" class="text-gray-800">Delivery</option>
                            </select>
                            <input id="searchInput" type="text" placeholder="Search staff..."
                                oninput="filterStaff()"
                                class="bg-white/20 border border-white/30 text-white placeholder-white/60 rounded-xl px-4 py-2 text-sm font-semibold outline-none w-52">
                            <button onclick="openStaffModal()"
                                class="bg-indigo-600 hover:bg-indigo-500 text-white px-5 py-2 rounded-xl font-bold transition shadow-md">
                                ➕ Add Staff
                            </button>
                        </div>
                    </div>

                    <div class="grid grid-cols-3 gap-6" id="staffGrid">
                        <c:forEach var="s" items="${staffList}">
                            <c:set var="badge">
                                <c:choose>
                                    <c:when test="${s.role == 'Manager'}">bg-indigo-100 text-indigo-700</c:when>
                                    <c:when test="${s.role == 'Cashier'}">bg-emerald-100 text-emerald-700</c:when>
                                    <c:when test="${s.role == 'Delivery'}">bg-orange-100 text-orange-700</c:when>
                                    <c:otherwise>bg-gray-100 text-gray-700</c:otherwise>
                                </c:choose>
                            </c:set>
                            <c:set var="emoji">
                                <c:choose>
                                    <c:when test="${s.role == 'Manager'}">&#x1F4CA;</c:when>
                                    <c:when test="${s.role == 'Cashier'}">&#x1F4B3;</c:when>
                                    <c:when test="${s.role == 'Delivery'}">&#x1F6F5;</c:when>
                                    <c:otherwise>&#x1F464;</c:otherwise>
                                </c:choose>
                            </c:set>
                            <c:set var="photoUrl" value="data:image/svg+xml,%3Csvg xmlns%3D%22http%3A//www.w3.org/2000/svg%22 width%3D%22120%22 height%3D%22120%22 viewBox%3D%220 0 120 120%22%3E%3Ccircle cx%3D%2260%22 cy%3D%2260%22 r%3D%2260%22 fill%3D%22%23e2e8f0%22/%3E%3Ctext x%3D%2260%22 y%3D%2276%22 font-size%3D%2240%22 text-anchor%3D%22middle%22 fill%3D%22%2394a3b8%22%3E%E2%9D%93%3C/text%3E%3C/svg%3E"/>

                            <div class="staff-card bg-white rounded-2xl shadow-lg overflow-hidden hover:-translate-y-1 transition duration-300" 
                                 data-role="${s.role}" 
                                 data-search="${s.fullName.toLowerCase()} ${s.email.toLowerCase()} ${s.phone.toLowerCase()}">
                                <div class="h-20 bg-gradient-to-r ${s.active ? 'from-slate-700 to-slate-600' : 'from-red-700 to-red-600'} relative">
                                    <img src="${photoUrl}" alt="${s.fullName}" class="absolute -bottom-8 left-6 w-20 h-20 rounded-2xl border-4 border-white shadow-lg object-cover">
                                    <div class="absolute top-4 right-4">
                                        <a href="${pageContext.request.contextPath}/admin/employees/toggle?id=${s.id}&active=${!s.active}" 
                                           class="text-xs font-bold px-3 py-1 rounded-full bg-white/20 text-white hover:bg-white/40 transition">
                                            ${s.active ? '🟢 Deactivate' : '🔴 Activate'}
                                        </a>
                                    </div>
                                </div>
                                <div class="pt-12 px-6 pb-6 text-sm">
                                    <div class="flex justify-between items-start mb-3">
                                        <div>
                                            <h3 class="font-black text-gray-800 text-lg leading-tight ${s.active ? '' : 'line-through text-gray-400'}">${s.fullName}</h3>
                                            <span class="inline-block ${badge} px-2 py-0.5 rounded-full text-xs font-bold mt-1">${emoji} ${s.role}</span>
                                        </div>
                                        <span class="text-xs text-gray-400">Since ${s.joinedDate.toString().substring(0,10)}</span>
                                    </div>
                                    <div class="space-y-1.5 text-gray-500 mb-4">
                                        <p>&#x1F4E7; ${s.email}</p>
                                        <p>&#x1F4DE; ${s.phone}</p>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
        </div>

        <!-- Add Staff Modal -->
        <div id="staffModal"
            class="hidden fixed inset-0 bg-black/50 z-50 flex items-center justify-center backdrop-blur-sm">
            <div class="bg-white rounded-2xl shadow-2xl w-[500px] overflow-hidden transform transition-all">
                <div class="p-6 border-b border-gray-100 flex justify-between items-center bg-gray-50">
                    <h2 class="text-xl font-black text-gray-800">Add New Staff</h2>
                    <button onclick="closeStaffModal()"
                        class="text-gray-400 hover:text-red-500 text-2xl leading-none">&times;</button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/employees/add" method="post" class="p-6 space-y-4">
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">Full Name</label>
                        <input type="text" name="fullName" required
                            class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition">
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Role</label>
                            <select name="role"
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition bg-white">
                                <option value="Manager">Manager</option>
                                <option value="Cashier">Cashier</option>
                                <option value="Delivery">Delivery</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Phone</label>
                            <input type="text" name="phone" required
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition">
                        </div>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Email Address</label>
                            <input type="email" name="email" required
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition">
                        </div>
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Password</label>
                            <input type="password" name="password" required
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition">
                        </div>
                    </div>
                    <div class="pt-4 flex justify-end gap-3 border-t border-gray-100 mt-6">
                        <button type="button" onclick="closeStaffModal()"
                            class="px-5 py-2 text-gray-500 font-bold hover:bg-gray-100 rounded-xl transition">Cancel</button>
                        <button type="submit"
                            class="px-5 py-2 bg-indigo-600 text-white font-bold rounded-xl hover:bg-indigo-700 transition shadow-md">Add
                            Member</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function filterStaff() {
                var role = document.getElementById('roleFilter').value;
                var q = document.getElementById('searchInput').value.toLowerCase();
                var cards = document.querySelectorAll('.staff-card');
                for (var i = 0; i < cards.length; i++) {
                    var roleMatch = role === 'all' || cards[i].getAttribute('data-role') === role;
                    var searchMatch = cards[i].getAttribute('data-search').indexOf(q) !== -1;
                    cards[i].style.display = (roleMatch && searchMatch) ? 'block' : 'none';
                }
            }

            function openStaffModal() {
                document.getElementById('staffModal').classList.remove('hidden');
            }
            function closeStaffModal() {
                document.getElementById('staffModal').classList.add('hidden');
            }
        </script>
    </body>

    </html>