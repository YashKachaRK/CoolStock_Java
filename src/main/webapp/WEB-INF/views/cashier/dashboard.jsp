<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Cashier Dashboard | CoolStock</title>
                <script src="https://cdn.tailwindcss.com"></script>
                <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap"
                    rel="stylesheet">
                <style>
                    body {
                        font-family: 'Outfit', sans-serif;
                    }

                    @media print {
                        .no-print {
                            display: none !important;
                        }

                        .ml-64 {
                            margin-left: 0 !important;
                        }
                    }
                </style>
            </head>

            <body class="bg-gray-100 min-h-screen">
                <div class="flex">

                    <!-- Cashier Sidebar -->
                    <div class="w-64 h-screen bg-emerald-700 text-white fixed flex flex-col justify-between no-print">
                        <div>
                            <div class="p-5 border-b border-emerald-600 flex items-center gap-3">
                                <span class="text-2xl">💳</span>
                                <div>
                                    <h2 class="text-lg font-black text-white">CoolStock</h2>
                                    <p class="text-[10px] text-emerald-200 uppercase font-black">Cashier Panel</p>
                                </div>
                            </div>
                            <nav class="mt-4 space-y-1 px-3">
                                <a href="${pageContext.request.contextPath}/cashier/dashboard"
                                    class="flex items-center gap-3 py-2.5 px-4 rounded-xl bg-emerald-600 font-semibold text-sm"><span>💸</span>
                                    Payment Verifier</a>
                                <a href="${pageContext.request.contextPath}/cashier/profile"
                                    class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-emerald-600 transition font-semibold text-sm"><span>👤</span>
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
                        <div
                            class="bg-gradient-to-r from-emerald-600 to-teal-600 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg no-print">
                            <div>
                                <h1 class="text-3xl font-black text-white">💳 ${staff.fullName} — Payment Verification
                                </h1>
                                <p class="opacity-80 mt-1 uppercase text-[10px] font-black tracking-widest">Verify cash
                                    received from Delivery Boy & generate invoice</p>
                            </div>
                            <div class="text-right">
                                <div id="liveDate" class="text-sm opacity-70"></div>
                                <div id="liveClock" class="text-2xl font-bold mt-1"></div>
                            </div>
                        </div>

                        <!-- Stats -->
                        <div class="grid grid-cols-3 gap-6 mb-8 no-print">
                            <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                                <p class="text-gray-400 text-xs font-black uppercase">Pending Verifications</p>
                                <p class="text-3xl font-black text-orange-500 mt-2">${countPending}</p>
                            </div>
                            <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                                <p class="text-gray-400 text-xs font-black uppercase">Verified Today</p>
                                <p class="text-3xl font-black text-emerald-600 mt-2">${countVerified}</p>
                            </div>
                            <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                                <p class="text-gray-400 text-xs font-black uppercase">Collected Today</p>
                                <p class="text-3xl font-black text-emerald-600 mt-2">₹${totalCashToday}</p>
                            </div>
                        </div>

                        <!-- Tabs Navigation -->
                        <div class="flex gap-6 mb-8 no-print border-b border-gray-200">
                            <button onclick="switchTab('pending')" id="tab-pending"
                                class="pb-4 px-2 text-sm font-black uppercase tracking-widest transition-all border-b-4 border-emerald-600 text-emerald-700">
                                ⏳ Awaiting Audit
                            </button>
                            <button onclick="switchTab('today')" id="tab-today"
                                class="pb-4 px-2 text-sm font-black uppercase tracking-widest transition-all border-b-4 border-transparent text-gray-400 hover:text-emerald-600">
                                📅 Verified Today
                            </button>
                            <button onclick="switchTab('history')" id="tab-history"
                                class="pb-4 px-2 text-sm font-black uppercase tracking-widest transition-all border-b-4 border-transparent text-gray-400 hover:text-emerald-600">
                                📜 Previous Orders
                            </button>
                        </div>

                        <!-- PENDING VERIFICATIONS -->
                        <div id="content-pending" class="tab-content transition-all duration-300">
                            <div
                                class="bg-white rounded-[2rem] shadow-xl overflow-hidden mb-8 no-print border border-orange-100">
                                <div class="p-8 border-b bg-orange-50 flex justify-between items-center">
                                    <div>
                                        <h2 class="text-xl font-black text-gray-800">⏳ Awaiting Cash Audit</h2>
                                        <p class="text-gray-400 text-xs font-bold mt-1">Verify physical cash received
                                            from Delivery Boy.</p>
                                    </div>
                                </div>
                                <div class="p-8 space-y-4">
                                    <c:if test="${empty pendingPayments}">
                                        <div class="text-center py-12 text-gray-400">
                                            <div class="text-5xl mb-3">☕</div>
                                            <p class="font-bold italic">All clear! No pending payments at this moment.
                                            </p>
                                        </div>
                                    </c:if>

                                    <c:forEach var="p" items="${pendingPayments}">
                                        <div
                                            class="border-2 border-orange-100 rounded-[1.5rem] p-6 bg-orange-50/50 flex justify-between items-center">
                                            <div>
                                                <div class="flex items-center gap-3 mb-2">
                                                    <span
                                                        class="font-black text-xl text-gray-800">#${p.orderNumber}</span>
                                                    <span
                                                        class="bg-orange-200 text-orange-800 text-[10px] font-black px-3 py-1 rounded-full uppercase tracking-tighter">Pending
                                                        Receipt</span>
                                                </div>
                                                <p class="text-sm font-bold text-gray-700">🏪 ${p.customer.shopName} —
                                                    ${p.customer.city}</p>
                                                <p class="text-xs text-gray-500 italic mt-1 font-medium">🛵 Handed over
                                                    by: <span
                                                        class="text-indigo-600 font-bold uppercase">${p.deliveryBoy.fullName}</span>
                                                </p>
                                                <p class="text-2xl font-black text-emerald-600 mt-3 font-mono">
                                                    ₹${p.totalAmount}</p>
                                            </div>
                                            <div class="flex flex-col gap-2">
                                                <form action="${pageContext.request.contextPath}/cashier/verifyPayment"
                                                    method="post">
                                                    <input type="hidden" name="orderId" value="${p.id}">
                                                    <button type="submit"
                                                        class="bg-emerald-600 text-white py-3 px-6 rounded-2xl font-black hover:bg-emerald-700 transition text-sm shadow-xl shadow-emerald-100">
                                                        ✅ Verify & Close
                                                    </button>
                                                </form>
                                                <button
                                                    onclick="previewInvoice('${p.orderNumber}', '${p.customer.shopName}', '${p.customer.city}', '${p.itemsSummary}', '${p.totalAmount}')"
                                                    class="text-[10px] font-black text-gray-400 uppercase tracking-widest hover:text-gray-900 transition">
                                                    👁️ Preview Invoice
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <!-- VERIFIED TABLE TODAY -->
                        <div id="content-today" class="tab-content hidden transition-all duration-300">
                            <div
                                class="bg-white rounded-[2rem] shadow-xl overflow-hidden no-print border border-gray-100">
                                <div class="p-8 border-b">
                                    <h2 class="text-xl font-black text-gray-800 uppercase tracking-tighter">Verified
                                        Payments Today</h2>
                                </div>
                                <div class="overflow-x-auto">
                                    <table class="w-full text-left text-sm">
                                        <thead
                                            class="bg-gray-50 text-[10px] uppercase font-black text-gray-400 tracking-widest">
                                            <tr>
                                                <th class="py-4 px-8">Order</th>
                                                <th class="px-8">Shop</th>
                                                <th class="px-8">Total Paid</th>
                                                <th class="px-8">Status</th>
                                                <th class="px-8 text-right">Invoice</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-gray-50">
                                            <c:if test="${empty verifiedToday}">
                                                <tr>
                                                    <td colspan="5"
                                                        class="py-12 text-center text-gray-400 font-bold italic">No
                                                        payments verified today yet.</td>
                                                </tr>
                                            </c:if>
                                            <c:forEach var="v" items="${verifiedToday}">
                                                <tr class="hover:bg-emerald-50/30 transition">
                                                    <td class="py-5 px-8 font-black text-gray-900">#${v.orderNumber}
                                                    </td>
                                                    <td class="px-8 font-bold text-gray-600">${v.customer.shopName}</td>
                                                    <td class="px-8 font-black text-emerald-600 font-mono italic">
                                                        ₹${v.totalAmount}</td>
                                                    <td class="px-8"><span
                                                            class="bg-emerald-100 text-emerald-800 px-3 py-1 rounded-full text-[10px] font-black uppercase">PAID</span>
                                                    </td>
                                                    <td class="px-8 text-right">
                                                        <button
                                                            onclick="previewInvoice('${v.orderNumber}', '${v.customer.shopName}', '${v.customer.city}', '${v.itemsSummary}', '${v.totalAmount}')"
                                                            class="text-blue-600 hover:underline font-bold text-xs uppercase italic">Print
                                                            🖨️</button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- VERIFIED HISTORY TABLE -->
                        <div id="content-history" class="tab-content hidden transition-all duration-300">
                            <div
                                class="bg-white rounded-[2rem] shadow-xl overflow-hidden no-print border border-gray-100">
                                <div class="p-8 border-b">
                                    <h2 class="text-xl font-black text-gray-800 uppercase tracking-tighter">Verified
                                        Payment History</h2>
                                    <p class="text-gray-400 text-xs font-bold mt-1">Full history of orders you have
                                        verified previously.</p>
                                </div>
                                <div class="overflow-x-auto">
                                    <table class="w-full text-left text-sm">
                                        <thead
                                            class="bg-gray-50 text-[10px] uppercase font-black text-gray-400 tracking-widest">
                                            <tr>
                                                <th class="py-4 px-8">Order</th>
                                                <th class="px-8">Date</th>
                                                <th class="px-8">Shop</th>
                                                <th class="px-8">Total Paid</th>
                                                <th class="px-8 text-right">Invoice</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-gray-50">
                                            <c:if test="${empty verifiedHistory}">
                                                <tr>
                                                    <td colspan="5"
                                                        class="py-12 text-center text-gray-400 font-bold italic">No
                                                        previous verification records found.</td>
                                                </tr>
                                            </c:if>
                                            <c:forEach var="h" items="${verifiedHistory}">
                                                <tr class="hover:bg-emerald-50/30 transition">
                                                    <td class="py-5 px-8 font-black text-gray-900">#${h.orderNumber}
                                                    </td>
                                                    <td class="px-8 text-gray-500 font-bold">
                                                        <fmt:formatDate value="${h.orderDate}" pattern="dd MMM YYYY" />
                                                    </td>
                                                    <td class="px-8 font-bold text-gray-600">${h.customer.shopName}</td>
                                                    <td class="px-8 font-black text-emerald-600 font-mono italic">
                                                        ₹${h.totalAmount}</td>
                                                    <td class="px-8 text-right">
                                                        <button
                                                            onclick="previewInvoice('${h.orderNumber}', '${h.customer.shopName}', '${h.customer.city}', '${h.itemsSummary}', '${h.totalAmount}')"
                                                            class="text-blue-600 hover:underline font-bold text-xs uppercase italic">View
                                                            📄</button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- INVOICE MODAL -->
                <div id="invoiceModal"
                    class="hidden fixed inset-0 bg-black/60 flex items-center justify-center z-50 no-print backdrop-blur-sm">
                    <div class="bg-white rounded-[3rem] shadow-2xl w-full max-w-xl overflow-hidden animate-fade-in">
                        <div
                            class="bg-gradient-to-r from-emerald-600 to-teal-700 text-white p-10 flex justify-between items-center">
                            <div>
                                <h1 class="text-4xl font-black">🍦 CoolStock</h1>
                                <p class="text-xs font-bold uppercase tracking-widest opacity-80 mt-1">Sales Ledger
                                    Entry</p>
                            </div>
                            <div class="text-right">
                                <p id="inv-id" class="font-black text-2xl tracking-tighter">INV-000</p>
                                <p id="inv-date" class="text-xs font-medium italic opacity-70"></p>
                            </div>
                        </div>
                        <div class="p-10">
                            <div class="flex justify-between items-start mb-8">
                                <div>
                                    <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-1">
                                        Customer Details</p>
                                    <p class="font-black text-gray-900 text-xl" id="inv-customer">—</p>
                                    <p class="text-gray-400 font-medium italic text-sm mt-1" id="inv-address">—</p>
                                </div>
                            </div>
                            <div class="mb-8 p-6 bg-gray-50 rounded-3xl border border-gray-100">
                                <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-3">Itemized
                                    Breakdown</p>
                                <p id="inv-items" class="text-sm text-gray-700 font-bold leading-relaxed">—</p>
                            </div>
                            <div class="flex justify-between items-center mb-10">
                                <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Total
                                    Transaction Value</p>
                                <p class="text-4xl font-black text-emerald-600 font-mono tracking-tighter">₹<span
                                        id="inv-total">0</span></p>
                            </div>
                            <div class="flex gap-4">
                                <button onclick="window.print()"
                                    class="flex-1 py-5 bg-emerald-600 text-white font-black rounded-[1.5rem] hover:bg-emerald-700 transition shadow-xl shadow-emerald-100">🖨️
                                    Generate Invoice</button>
                                <button onclick="closeInvoice()"
                                    class="flex-1 py-5 bg-gray-100 text-gray-900 font-black rounded-[1.5rem] hover:bg-gray-200 transition">Close</button>
                            </div>
                        </div>
                    </div>
                </div>

                <script>
                    function switchTab(tab) {
                        // Hide all contents
                        document.querySelectorAll('.tab-content').forEach(c => c.classList.add('hidden'));
                        // Remove active classes from all buttons
                        document.querySelectorAll('[id^="tab-"]').forEach(b => {
                            b.classList.remove('border-emerald-600', 'text-emerald-700');
                            b.classList.add('border-transparent', 'text-gray-400');
                        });

                        // Show selected content
                        document.getElementById('content-' + tab).classList.remove('hidden');
                        // Add active classes to selected button
                        const btn = document.getElementById('tab-' + tab);
                        btn.classList.add('border-emerald-600', 'text-emerald-700');
                        btn.classList.remove('border-transparent', 'text-gray-400');
                    }

                    function previewInvoice(orderId, customer, city, items, amount) {
                        document.getElementById('inv-id').innerText = 'INV-' + orderId;
                        document.getElementById('inv-date').innerText = new Date().toDateString();
                        document.getElementById('inv-customer').innerText = customer;
                        document.getElementById('inv-address').innerText = city;
                        document.getElementById('inv-items').innerText = items;
                        document.getElementById('inv-total').innerText = amount;
                        document.getElementById('invoiceModal').classList.remove('hidden');
                    }
                    function closeInvoice() { document.getElementById('invoiceModal').classList.add('hidden'); }
                    setInterval(() => {
                        const now = new Date();
                        document.getElementById('liveClock').innerText = now.toLocaleTimeString();
                        document.getElementById('liveDate').innerText = now.toDateString();
                    }, 1000);
                </script>
            </body>

            </html>