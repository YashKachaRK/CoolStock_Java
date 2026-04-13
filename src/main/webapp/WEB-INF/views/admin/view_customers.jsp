<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Manage Customers | CoolStock Admin</title>
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
                        class="bg-gradient-to-r from-purple-700 to-pink-600 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
                        <div>
                            <h1 class="text-3xl font-black">&#x1F3EA; Manage Customers</h1>
                            <p class="opacity-70 mt-1">B2B wholesale shop owners who place bulk orders</p>
                        </div>
                        <div class="flex gap-4 items-center">
                            <select id="cityFilter" onchange="filterCustomers()"
                                class="bg-white/20 border border-white/30 text-white font-bold rounded-xl px-4 py-2 text-sm outline-none">
                                <option value="" class="text-gray-800">All Cities</option>
                                <option value="Ahmedabad" class="text-gray-800">Ahmedabad</option>
                                <option value="Surat" class="text-gray-800">Surat</option>
                                <option value="Vadodara" class="text-gray-800">Vadodara</option>
                                <option value="Rajkot" class="text-gray-800">Rajkot</option>
                                <option value="Bhavnagar" class="text-gray-800">Bhavnagar</option>
                                <option value="Jamnagar" class="text-gray-800">Jamnagar</option>
                                <option value="Gandhinagar" class="text-gray-800">Gandhinagar</option>
                                <option value="Anand" class="text-gray-800">Anand</option>
                            </select>
                            <input id="searchInput" type="text" placeholder="Search customer..."
                                oninput="filterCustomers()"
                                class="bg-white/20 border border-white/30 text-white placeholder-white/60 rounded-xl px-4 py-2 text-sm font-semibold outline-none w-52">
                            <button onclick="openCustomerModal()"
                                class="bg-purple-900 hover:bg-purple-800 text-white px-5 py-2 rounded-xl font-bold transition shadow-md">
                                ➕ Add Customer
                            </button>
                        </div>
                    </div>

                    <!-- Stats -->
                    <div class="grid grid-cols-3 gap-6 mb-8">
                        <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition">
                            <p class="text-gray-400 text-sm">Total Customers</p>
                            <p class="text-3xl font-black text-purple-700 mt-1">${totalCustomers}</p>
                        </div>
                        <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition">
                            <p class="text-gray-400 text-sm">Active This Month</p>
                            <p class="text-3xl font-black text-green-600 mt-1">${activeThisMonthCount}</p>
                        </div>
                        <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition">
                            <p class="text-gray-400 text-sm">Total Orders This Month</p>
                            <p class="text-3xl font-black text-indigo-600 mt-1">${monthlyOrdersCount}</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-3 gap-6" id="customerGrid">
                        <c:forEach var="c" items="${customersList}">
                            <c:set var="defaultCustSvg" value="data:image/svg+xml,%3Csvg xmlns%3D%22http%3A//www.w3.org/2000/svg%22 width%3D%22120%22 height%3D%22120%22 viewBox%3D%220 0 120 120%22%3E%3Ccircle cx%3D%2260%22 cy%3D%2260%22 r%3D%2260%22 fill%3D%22%23f3e8ff%22/%3E%3Ctext x%3D%2260%22 y%3D%2276%22 font-size%3D%2240%22 text-anchor%3D%22middle%22 fill%3D%22%239333ea%22%3E&#x1F3EA;%3C/text%3E%3C/svg%3E"/>
                            <div class="cust-card bg-white rounded-2xl shadow-lg overflow-hidden hover:-translate-y-1 transition duration-300"
                                 data-search="${c.shopName.toLowerCase()} ${c.ownerName.toLowerCase()} ${c.area.toLowerCase()} ${c.city.toLowerCase()}"
                                 data-city="${c.city.toLowerCase()}">
                                <div class="h-20 bg-gradient-to-r from-purple-600 to-pink-500 relative">
                                    <img src="${defaultCustSvg}" alt="${c.ownerName}" 
                                         class="absolute -bottom-8 left-6 w-20 h-20 rounded-2xl border-4 border-white shadow-lg object-cover">
                                    
                                    <c:choose>
                                        <c:when test="${c.active}">
                                            <a href="${pageContext.request.contextPath}/admin/customers/toggle?id=${c.id}&active=false" 
                                               class="absolute top-4 right-4 bg-red-500 text-white py-1 px-3 rounded-xl text-xs font-bold shadow hover:bg-red-600 transition">Deactivate</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/admin/customers/toggle?id=${c.id}&active=true" 
                                               class="absolute top-4 right-4 bg-green-500 text-white py-1 px-3 rounded-xl text-xs font-bold shadow hover:bg-green-600 transition">Activate</a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="pt-12 px-6 pb-6 text-sm">
                                    <div class="flex justify-between items-start mb-1">
                                        <div>
                                            <h3 class="font-black text-gray-800 text-base leading-tight">${c.shopName}</h3>
                                            <p class="text-gray-500 text-xs">&#x1F464; ${c.ownerName}</p>
                                        </div>
                                        <span class="text-xs text-gray-400">Since ${c.joinedDate.toString().substring(0, 10)}</span>
                                    </div>
                                    <div class="space-y-1 text-xs text-gray-500 mt-3 mb-4">
                                        <p>&#x1F4CD; ${c.area}, ${c.city}</p>
                                        <p>&#x1F4DE; ${c.phone}</p>
                                        <p>&#x1F4E7; ${not empty c.email ? c.email : 'N/A'}</p>
                                    </div>
                                    <div class="grid grid-cols-2 gap-2 bg-gray-50 rounded-xl p-3 text-center">
                                        <div>
                                            <p class="text-xs text-gray-400">Account</p>
                                            <p class="font-black uppercase text-[10px]">
                                                <c:choose>
                                                    <c:when test="${c.active}"><span class="text-green-600">Active</span></c:when>
                                                    <c:otherwise><span class="text-red-500">Inactive</span></c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                        <div>
                                            <p class="text-xs text-gray-400">Total Spend</p>
                                            <p class="font-black text-green-600 text-xs">&#x20B9;${c.totalSpend}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
        </div>

        <!-- Add Customer Modal -->
        <div id="customerModal"
            class="hidden fixed inset-0 bg-black/50 z-50 flex items-center justify-center backdrop-blur-sm">
            <div class="bg-white rounded-2xl shadow-2xl w-[500px] overflow-hidden transform transition-all">
                <div class="p-6 border-b border-gray-100 flex justify-between items-center bg-purple-50">
                    <h2 class="text-xl font-black text-gray-800">Add New Customer</h2>
                    <button onclick="closeCustomerModal()"
                        class="text-gray-400 hover:text-red-500 text-2xl leading-none">&times;</button>
                </div>
                <form id="addCustomerForm" action="${pageContext.request.contextPath}/admin/customers/add" method="POST" class="p-6 space-y-4">
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">Shop/Business Name</label>
                        <input type="text" id="custName" name="shopName" required
                            class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition">
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">Owner Name</label>
                        <input type="text" id="custOwner" name="ownerName" required
                            class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition">
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">City</label>
                        <select name="city" required
                            class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition">
                            <option value="">-- Select Gujarat City --</option>
                            <option value="Ahmedabad">Ahmedabad</option>
                            <option value="Surat">Surat</option>
                            <option value="Vadodara">Vadodara</option>
                            <option value="Rajkot">Rajkot</option>
                            <option value="Bhavnagar">Bhavnagar</option>
                            <option value="Jamnagar">Jamnagar</option>
                            <option value="Gandhinagar">Gandhinagar</option>
                            <option value="Junagadh">Junagadh</option>
                            <option value="Anand">Anand</option>
                            <option value="Navsari">Navsari</option>
                            <option value="Morbi">Morbi</option>
                            <option value="Nadiad">Nadiad</option>
                            <option value="Bharuch">Bharuch</option>
                            <option value="Porbandar">Porbandar</option>
                        </select>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Phone</label>
                            <input type="text" id="custPhone" name="phone" required
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition">
                        </div>
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Local Area</label>
                            <input type="text" id="custArea" name="area" required
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition">
                        </div>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Email Address (Optional)</label>
                            <input type="email" id="custEmail" name="email"
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition">
                        </div>
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Password</label>
                            <input type="password" id="custPassword" name="password" required
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition">
                        </div>
                    </div>
                    <div class="pt-4 flex justify-end gap-3 border-t border-gray-100 mt-6">
                        <button type="button" onclick="closeCustomerModal()"
                            class="px-5 py-2 text-gray-500 font-bold hover:bg-gray-100 rounded-xl transition">Cancel</button>
                        <button type="submit"
                            class="px-5 py-2 bg-purple-600 text-white font-bold rounded-xl hover:bg-purple-700 transition shadow-md">Add Customer</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function filterCustomers() {
                var q = document.getElementById('searchInput').value.toLowerCase();
                var cityFilter = document.getElementById('cityFilter').value.toLowerCase();
                var cards = document.querySelectorAll('.cust-card');
                for (var i = 0; i < cards.length; i++) {
                    var searchData = cards[i].getAttribute('data-search');
                    var cityData = cards[i].getAttribute('data-city');
                    var textMatches = searchData.indexOf(q) !== -1;
                    var cityMatches = cityFilter === "" || cityData === cityFilter;
                    cards[i].style.display = (textMatches && cityMatches) ? 'block' : 'none';
                }
            }

            function openCustomerModal() {
                document.getElementById('customerModal').classList.remove('hidden');
            }
            function closeCustomerModal() {
                document.getElementById('customerModal').classList.add('hidden');
            }
        </script>
    </body>

    </html>