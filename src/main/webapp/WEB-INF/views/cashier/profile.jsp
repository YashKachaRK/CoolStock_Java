<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>My Profile | CoolStock — Cashier</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Outfit', sans-serif;
            }

            input[type=file] {
                display: none;
            }
        </style>
    </head>

    <body class="bg-gray-100 min-h-screen">
        <div class="flex">
            <!-- Cashier Sidebar -->
            <div class="w-64 h-screen bg-emerald-700 text-white fixed flex flex-col justify-between">
                <div>
                    <div class="p-5 border-b border-emerald-600 flex items-center gap-3"><span
                            class="text-2xl">💳</span>
                        <div>
                            <h2 class="text-lg font-black">CoolStock</h2>
                            <p class="text-xs text-emerald-200">Cashier Panel</p>
                        </div>
                    </div>
                    <nav class="mt-4 space-y-1 px-3">
                        <a href="${pageContext.request.contextPath}/cashier/dashboard"
                            class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-emerald-600 transition font-semibold text-sm"><span>💸</span>
                            Payment Verifier</a>
                        <a href="${pageContext.request.contextPath}/cashier/profile"
                            class="flex items-center gap-3 py-2.5 px-4 rounded-xl bg-emerald-600 font-semibold text-sm"><span>👤</span>
                            My Profile</a>
                    </nav>
                </div>
                <div class="mb-5 px-4">
                    <a href="${pageContext.request.contextPath}/logout"
                        class="block py-3 px-4 bg-red-600 rounded-xl hover:bg-red-700 transition text-center font-bold text-sm text-white">🚪
                        Logout</a>
                </div>
            </div>
            <div class="ml-64 p-8 w-full max-w-4xl">
                <div
                    class="bg-gradient-to-r from-emerald-600 to-teal-600 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
                    <div>
                        <h1 class="text-3xl font-black">👤 My Profile</h1>
                        <p class="opacity-70 mt-1">View and update your details</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/cashier/dashboard"
                        class="bg-white/20 px-4 py-2 rounded-xl text-sm font-semibold hover:bg-white/30 transition">←
                        Dashboard</a>
                </div>
                <div class="grid grid-cols-3 gap-6">
                    <div class="bg-white rounded-2xl shadow-lg p-6 flex flex-col items-center text-center">
                        <div class="relative mb-4">
                            <img id="photoPreview" src="https://ui-avatars.com/api/?name=${staff.fullName}&background=059669&color=fff" alt="Profile"
                                class="w-36 h-36 rounded-full border-4 border-emerald-100 shadow-md object-cover bg-gray-100">
                            <button onclick="document.getElementById('fileInput').click()"
                                class="absolute bottom-1 right-1 bg-emerald-600 text-white w-9 h-9 rounded-full flex items-center justify-center text-lg shadow hover:bg-emerald-800 transition">📷</button>
                        </div>
                        <input type="file" id="fileInput" accept="image/*" onchange="uploadPhoto(event)">
                        <p class="font-black text-xl text-gray-800" id="displayName">${staff.fullName}</p>
                        <span class="bg-emerald-100 text-emerald-700 px-3 py-1 rounded-full text-xs font-bold mt-1">💳
                            ${staff.role}</span>
                        <button onclick="document.getElementById('fileInput').click()"
                            class="mt-4 w-full py-2 bg-emerald-600 text-white rounded-xl font-semibold text-sm hover:bg-emerald-800 transition">📷
                            Change Photo</button>
                        <p class="text-xs text-gray-400 mt-2">Staff Key: ${staff.staffKey}</p>
                    </div>
                    <div class="col-span-2 bg-white rounded-2xl shadow-lg p-6">
                        <div class="flex justify-between items-center mb-6">
                            <h2 class="text-xl font-bold text-gray-800">Profile Details</h2>
                            <button id="editBtn" onclick="toggleEdit()"
                                class="bg-emerald-600 text-white px-4 py-2 rounded-xl text-sm font-bold hover:bg-emerald-800 transition">✏️
                                Edit Profile</button>
                        </div>
                        <div class="space-y-4">
                            <div class="grid grid-cols-2 gap-4">
                                <div><label class="text-xs font-bold text-gray-400 uppercase">Full Name</label>
                                    <p id="view-name" class="font-semibold text-gray-800 mt-0.5">${staff.fullName}</p>
                                    <input id="edit-name" type="text" value="${staff.fullName}"
                                        class="hidden w-full border-2 border-gray-200 rounded-xl px-3 py-2 mt-0.5 text-sm outline-none">
                                </div>
                                <div><label class="text-xs font-bold text-gray-400 uppercase">Role</label>
                                    <p class="font-semibold text-gray-800 mt-0.5">💳 ${staff.role}</p>
                                </div>
                            </div>
                            <div class="grid grid-cols-2 gap-4">
                                <div><label class="text-xs font-bold text-gray-400 uppercase">Email</label>
                                    <p id="view-email" class="font-semibold text-gray-800 mt-0.5">${staff.email}</p>
                                    <input id="edit-email" type="email" value="${staff.email}"
                                        class="hidden w-full border-2 border-gray-200 rounded-xl px-3 py-2 mt-0.5 text-sm outline-none">
                                </div>
                                <div><label class="text-xs font-bold text-gray-400 uppercase">Contact</label>
                                    <p id="view-phone" class="font-semibold text-gray-800 mt-0.5">${staff.phone}</p>
                                    <input id="edit-phone" type="text" value="${staff.phone}"
                                        class="hidden w-full border-2 border-gray-200 rounded-xl px-3 py-2 mt-0.5 text-sm outline-none">
                                </div>
                            </div>
                            <div><label class="text-xs font-bold text-gray-400 uppercase">Account Status</label>
                                <p class="font-semibold text-emerald-600 mt-0.5">${staff.active ? 'Active' : 'Inactive'}</p>
                            </div>
                        </div>
                        <button id="saveBtn" onclick="saveProfile()"
                            class="hidden mt-6 w-full py-3 bg-emerald-600 text-white font-black rounded-2xl hover:bg-emerald-700 transition">💾
                            Save Changes</button>
                        <div id="savedMsg"
                            class="hidden mt-4 bg-green-50 text-green-700 p-3 rounded-xl text-sm font-semibold text-center">
                            ✅ Profile updated successfully!</div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            function toggleEdit() { const e = !document.getElementById('saveBtn').classList.contains('hidden');['name', 'email', 'phone'].forEach(f => { document.getElementById('view-' + f).classList.toggle('hidden', !e); document.getElementById('edit-' + f).classList.toggle('hidden', e); }); document.getElementById('saveBtn').classList.toggle('hidden'); document.getElementById('editBtn').innerText = e ? '✏️ Edit Profile' : '✖ Cancel'; }
            function saveProfile() { 
                // In a real app, this would be an AJAX call
                document.getElementById('view-name').innerText = document.getElementById('edit-name').value;
                document.getElementById('view-email').innerText = document.getElementById('edit-email').value;
                document.getElementById('view-phone').innerText = document.getElementById('edit-phone').value;
                document.getElementById('displayName').innerText = document.getElementById('edit-name').value;
                toggleEdit(); 
                document.getElementById('savedMsg').classList.remove('hidden'); 
                setTimeout(() => document.getElementById('savedMsg').classList.add('hidden'), 3000); 
            }
            function uploadPhoto(e) { const r = new FileReader(); r.onload = ev => { document.getElementById('photoPreview').src = ev.target.result; }; r.readAsDataURL(e.target.files[0]); }
        </script>
    </body>

    </html>