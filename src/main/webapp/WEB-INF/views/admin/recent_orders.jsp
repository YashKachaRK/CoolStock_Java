<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>Recent Orders | CoolStock Admin</title>
                <script src="https://cdn.tailwindcss.com"></script>
                <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap"
                    rel="stylesheet">
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
                                class="bg-gradient-to-r from-emerald-700 to-teal-600 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
                                <div>
                                    <h1 class="text-3xl font-black">&#x1F9FE; Recent Orders</h1>
                                    <p class="opacity-70 mt-1">Track and manage recent customer orders</p>
                                </div>
                                <div class="flex gap-4 items-center">
                                    <label class="text-white text-sm font-bold opacity-80 mt-1">Date Range:</label>
                                    <input id="dateFrom" type="date" onchange="filterOrders()"
                                        class="bg-white/20 border border-white/30 text-white placeholder-white/60 rounded-xl px-3 py-2 text-sm font-semibold outline-none w-36">
                                    <span class="text-white text-sm font-bold opacity-80 mt-1">to</span>
                                    <input id="dateTo" type="date" onchange="filterOrders()"
                                        class="bg-white/20 border border-white/30 text-white placeholder-white/60 rounded-xl px-3 py-2 text-sm font-semibold outline-none w-36">
                                    <select id="statusFilter" onchange="filterOrders()"
                                        class="bg-white/20 border border-white/30 text-white rounded-xl px-4 py-2 text-sm font-semibold outline-none w-40">
                                        <option value="all" class="text-gray-800">All Statuses</option>
                                        <option value="Processing" class="text-gray-800">Processing</option>
                                        <option value="Shipped" class="text-gray-800">Shipped</option>
                                        <option value="Delivered" class="text-gray-800">Delivered</option>
                                        <option value="Cancelled" class="text-gray-800">Cancelled</option>
                                    </select>
                                    <input id="searchInput" type="text" placeholder="Search ID, Customer, Boy..."
                                        oninput="filterOrders()"
                                        class="bg-white/20 border border-white/30 text-white placeholder-white/60 rounded-xl px-4 py-2 text-sm font-semibold outline-none w-64">
                                    <button onclick="clearFilters()"
                                        class="bg-white/10 hover:bg-white/20 text-white px-3 py-2 rounded-xl text-xs font-bold transition border border-white/20">
                                        🔄 Clear
                                    </button>
                                </div>
                            </div>

                            <!-- Stats -->
                            <div class="grid grid-cols-4 gap-6 mb-8">
                                <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition">
                                    <p class="text-gray-400 text-sm">Total Orders (Today)</p>
                                    <p class="text-3xl font-black text-emerald-700 mt-1">${todayCount}</p>
                                </div>
                                <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition">
                                    <p class="text-gray-400 text-sm">Revenue (Today)</p>
                                    <p class="text-3xl font-black text-teal-600 mt-1">&#x20B9;${todayRevenue}</p>
                                </div>
                                <div
                                    class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition border-l-4 border-orange-400">
                                    <p class="text-gray-400 text-sm">Processing</p>
                                    <p class="text-3xl font-black text-orange-500 mt-1">${processingCount}</p>
                                </div>
                                <div
                                    class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition border-l-4 border-blue-400">
                                    <p class="text-gray-400 text-sm">Shipped</p>
                                    <p class="text-3xl font-black text-blue-500 mt-1">${shippedCount}</p>
                                </div>
                            </div>

                            <!-- Orders Table -->
                            <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
                                <div class="p-6 border-b border-gray-100 bg-gray-50 flex justify-between items-center">
                                    <h2 class="text-xl font-black text-gray-800">Order Logs</h2>
                                    <button
                                        class="bg-emerald-100 text-emerald-700 px-4 py-1.5 rounded-full text-xs font-bold hover:bg-emerald-200 transition">
                                        📥 Export CSV
                                    </button>
                                </div>
                                <div class="overflow-x-auto">
                                    <table class="w-full text-left border-collapse">
                                        <thead>
                                            <tr
                                                class="text-xs uppercase text-gray-400 border-b border-gray-100 bg-white">
                                                <th class="px-6 py-4 font-bold tracking-wider">Order ID</th>
                                                <th class="px-6 py-4 font-bold tracking-wider">Customer</th>
                                                <th class="px-6 py-4 font-bold tracking-wider">Date & Time</th>
                                                <th class="px-6 py-4 font-bold tracking-wider">Delivery Boy</th>
                                                <th class="px-6 py-4 font-bold tracking-wider">Items Summary</th>
                                                <th class="px-6 py-4 font-bold tracking-wider">Amount</th>
                                                <th class="px-6 py-4 font-bold tracking-wider">Status</th>
                                                <th class="px-6 py-4 font-bold tracking-wider text-center">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody id="orderTableBody" class="text-sm">
                                            <c:forEach var="o" items="${ordersList}" varStatus="loop">
                                                <c:set var="statusColor">
                                                    <c:choose>
                                                        <c:when test="${o.status == 'Processing'}">bg-orange-100
                                                            text-orange-600</c:when>
                                                        <c:when test="${o.status == 'Shipped'}">bg-blue-100
                                                            text-blue-600</c:when>
                                                        <c:when test="${o.status == 'Delivered'}">bg-green-100
                                                            text-green-600</c:when>
                                                        <c:otherwise>bg-red-100 text-red-600</c:otherwise>
                                                    </c:choose>
                                                </c:set>
                                                <tr class="order-row border-b border-gray-50 hover:bg-gray-50/50 transition"
                                                    data-id="${o.orderNumber.toLowerCase()}" data-db-id="${o.id}"
                                                    data-status="${o.status}"
                                                    data-date="${o.orderDate.toString().substring(0,10)}"
                                                    data-customer="${o.customer != null ? o.customer.shopName : 'Unknown'}"
                                                    data-dboy="${o.deliveryBoy != null ? o.deliveryBoy.fullName : 'Not Assigned'}"
                                                    data-amount="&#x20B9;${o.totalAmount}"
                                                    data-items="${o.itemsSummary}">
                                                    <td class="px-6 py-4 font-black text-gray-800">${o.orderNumber}</td>
                                                    <td class="px-6 py-4 font-semibold text-gray-700">${o.customer !=
                                                        null ? o.customer.shopName : 'Unknown'}</td>
                                                    <td class="px-6 py-4 text-gray-500 text-xs">
                                                        <fmt:formatDate value="${o.orderDate}" pattern="dd-MM-yyyy" />
                                                    </td>
                                                    <td class="px-6 py-4 font-bold text-blue-600 text-xs">
                                                        ${o.deliveryBoy != null ? o.deliveryBoy.fullName : 'Not
                                                        Assigned'}</td>
                                                    <td class="px-6 py-4 text-gray-500 text-xs truncate max-w-[150px]"
                                                        title="${o.itemsSummary}">${o.itemsSummary}</td>
                                                    <td class="px-6 py-4 font-black text-emerald-600">
                                                        &#x20B9;${o.totalAmount}</td>
                                                    <td class="px-6 py-4">
                                                        <span
                                                            class="px-3 py-1 rounded-full text-xs font-bold ${statusColor}">${o.status}</span>
                                                    </td>
                                                    <td class="px-6 py-4 text-center">
                                                        <div class="flex gap-2 justify-center">
                                                            <button onclick="viewFlow(${o.id}, '${o.orderNumber}')"
                                                                class="text-xs font-bold text-emerald-600 bg-emerald-50 px-3 py-1.5 rounded-lg hover:bg-emerald-100 transition border border-emerald-100 uppercase tracking-tighter"
                                                                title="View Audit Trail">Flow</button>
                                                            <button onclick="openOrderModal(this.closest('tr'))"
                                                                class="text-gray-400 hover:text-emerald-600 transition p-2 bg-white rounded-full shadow-sm border border-gray-100"
                                                                title="View Details">👁️</button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                </div>

                <!-- View Order Details Modal -->
                <div id="orderViewModal"
                    class="hidden fixed inset-0 bg-black/50 z-50 flex items-center justify-center backdrop-blur-sm px-4">
                    <div class="bg-white rounded-2xl shadow-2xl w-[600px] overflow-hidden transform transition-all">
                        <div class="p-6 border-b border-gray-100 flex justify-between items-center bg-emerald-50">
                            <h2 class="text-xl font-black text-gray-800" id="modalOrderTitle">Order Details</h2>
                            <button onclick="closeOrderModal()"
                                class="text-gray-400 hover:text-red-500 text-2xl leading-none">&times;</button>
                        </div>
                        <div class="p-6">
                            <div class="grid grid-cols-2 gap-4 mb-4">
                                <div>
                                    <p class="text-xs text-gray-400 font-bold uppercase mb-1">Customer</p>
                                    <p class="text-sm font-bold text-gray-800" id="modalCustomerName"></p>
                                </div>
                                <div>
                                    <p class="text-xs text-gray-400 font-bold uppercase mb-1">Date</p>
                                    <p class="text-sm font-bold text-gray-800" id="modalOrderDate"></p>
                                </div>
                                <div>
                                    <p class="text-xs text-gray-400 font-bold uppercase mb-1">Delivery Boy</p>
                                    <p class="text-sm font-bold text-gray-800" id="modalDeliveryBoy"></p>
                                </div>
                                <div>
                                    <p class="text-xs text-gray-400 font-bold uppercase mb-1">Total Amount</p>
                                    <p class="text-sm font-black text-emerald-600" id="modalTotalAmount"></p>
                                </div>
                            </div>
                            <div class="border border-gray-200 rounded-xl overflow-hidden mb-6">
                                <table class="w-full text-left text-sm">
                                    <thead class="bg-gray-50 border-b border-gray-200">
                                        <tr>
                                            <th class="px-4 py-2 font-bold text-gray-600">Product Name</th>
                                        </tr>
                                    </thead>
                                    <tbody id="modalItemsBody" class="divide-y divide-gray-100">
                                        <!-- Items injected here -->
                                    </tbody>
                                </table>
                            </div>
                            <div class="flex justify-end gap-3 pt-4 border-t border-gray-100">
                                <button onclick="downloadInvoicePDF()"
                                    class="bg-emerald-600 hover:bg-emerald-700 text-white font-bold py-2 px-5 rounded-xl shadow transition">
                                    📄 Download Invoice (PDF)
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                </div>
                </div>

                <!-- Flow Timeline Modal (Reused from Manager Panel) -->
                <div id="flowModal"
                    class="fixed inset-0 bg-gray-900/60 backdrop-blur-sm z-[60] hidden flex items-center justify-center p-4">
                    <div
                        class="bg-white rounded-[2.5rem] w-full max-w-lg shadow-2xl border border-white/20 relative overflow-hidden transform transition-all">
                        <div
                            class="absolute top-0 right-0 w-64 h-64 bg-emerald-50 rounded-full -mr-32 -mt-32 blur-[80px]">
                        </div>

                        <div class="p-8 relative z-10">
                            <div class="flex justify-between items-center mb-8">
                                <div>
                                    <h3 class="text-2xl font-black text-gray-900 tracking-tight"
                                        id="flowModalOrderNumber">ORD-XXXXX</h3>
                                    <p class="text-[10px] font-black text-emerald-500 uppercase tracking-[0.2em] mt-1">
                                        Lifecycle Audit Trail</p>
                                </div>
                                <button onclick="closeFlowModal()"
                                    class="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center font-bold text-gray-400 hover:text-gray-900 transition">✕</button>
                            </div>

                            <div id="timelineContainer"
                                class="space-y-6 relative before:absolute before:left-[11px] before:top-2 before:bottom-2 before:w-[2px] before:bg-gray-100">
                                <!-- Timeline items will be injected here -->
                            </div>

                            <div class="mt-10">
                                <button onclick="closeFlowModal()"
                                    class="w-full py-4 bg-gray-900 text-white rounded-2xl text-xs font-black uppercase tracking-widest hover:bg-black transition shadow-xl">
                                    Close Audit
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <script>
                    var currentOrderForModalId = null;
                    function openOrderModal(tr) {
                        var orderId = tr.getAttribute('data-id').toUpperCase();
                        currentOrderForModalId = orderId;

                        document.getElementById('modalOrderTitle').innerText = 'Order Details: ' + orderId;
                        document.getElementById('modalCustomerName').innerText = tr.getAttribute('data-customer');
                        document.getElementById('modalOrderDate').innerText = tr.getAttribute('data-date');
                        document.getElementById('modalDeliveryBoy').innerText = tr.getAttribute('data-dboy');
                        document.getElementById('modalTotalAmount').innerHTML = tr.getAttribute('data-amount');

                        var itemsBody = document.getElementById('modalItemsBody');
                        itemsBody.innerHTML = '<tr><td class="px-4 py-2 text-gray-700">' + (tr.getAttribute('data-items') || "No items") + '</td></tr>';

                        document.getElementById('orderViewModal').classList.remove('hidden');
                    }

                    function closeOrderModal() {
                        document.getElementById('orderViewModal').classList.add('hidden');
                    }

                    function downloadInvoicePDF() {
                        if (currentOrderForModalId) {
                            alert("Initiating Invoice PDF download for " + currentOrderForModalId + "\nThe functionality works directly with Java endpoint.");
                            window.location.href = '${pageContext.request.contextPath}/admin/orders/invoicePdf?id=' + encodeURIComponent(currentOrderForModalId);
                        }
                    }

                    function filterOrders() {
                        var q = document.getElementById('searchInput').value.toLowerCase();
                        var status = document.getElementById('statusFilter').value;
                        var dateFrom = document.getElementById('dateFrom').value;
                        var dateTo = document.getElementById('dateTo').value;

                        var rows = document.querySelectorAll('.order-row');

                        for (var i = 0; i < rows.length; i++) {
                            var r = rows[i];
                            var orderId = r.getAttribute('data-id');
                            var cust = r.getAttribute('data-customer').toLowerCase();
                            var dboy = r.getAttribute('data-dboy').toLowerCase();

                            var matchSearch = orderId.indexOf(q) !== -1 || cust.indexOf(q) !== -1 || dboy.indexOf(q) !== -1;
                            var matchStatus = status === 'all' || r.getAttribute('data-status') === status;
                            var matchDate = true;

                            var rowDate = r.getAttribute('data-date'); // YYYY-MM-DD
                            if (dateFrom && rowDate < dateFrom) matchDate = false;
                            if (dateTo && rowDate > dateTo) matchDate = false;

                            r.style.display = (matchSearch && matchStatus && matchDate) ? '' : 'none';
                        }
                    }

                    function clearFilters() {
                        document.getElementById('searchInput').value = '';
                        document.getElementById('statusFilter').value = 'all';
                        document.getElementById('dateFrom').value = '';
                        document.getElementById('dateTo').value = '';
                        filterOrders();
                    }

                    async function viewFlow(orderId, orderNumber) {
                        document.getElementById('flowModalOrderNumber').innerText = orderNumber;
                        const container = document.getElementById('timelineContainer');
                        container.innerHTML = '<p class="text-center py-10 text-xs font-bold text-gray-400 animate-pulse">Scanning audit logs...</p>';
                        document.getElementById('flowModal').classList.remove('hidden');

                        try {
                            const response = await fetch(`${pageContext.request.contextPath}/admin/orders/history?id=` + orderId);
                            const history = await response.json();

                            container.innerHTML = '';
                            if (history.length === 0) {
                                container.innerHTML = '<p class="text-center py-10 text-xs font-bold text-gray-400">No logs found for this order.</p>';
                            } else {
                                history.forEach((h, index) => {
                                    const date = new Date(h.performedAt);
                                    const timeStr = date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
                                    const dateStr = date.toLocaleDateString([], { day: '2-digit', month: 'short' });

                                    let performerHtml = '';
                                    if (h.performerName) {
                                        performerHtml = `<p class="text-[9px] font-black text-emerald-400 uppercase tracking-widest mt-1 italic">👤 By: \${h.performerName}</p>`;
                                    }

                                    const item = `
                                <div class="relative pl-10">
                                    <div class="absolute left-0 top-1.5 w-6 h-6 rounded-full \${index === history.length - 1 ? 'bg-emerald-600 border-4 border-emerald-100' : 'bg-gray-200'} z-10"></div>
                                    <div>
                                        <div class="flex justify-between items-start">
                                            <h4 class="font-black text-gray-900 text-sm tracking-tight">\${h.action}</h4>
                                            <span class="text-[9px] font-black text-gray-400 uppercase">\${dateStr}, \${timeStr}</span>
                                        </div>
                                        <p class="text-[11px] text-gray-500 font-medium mt-0.5">\${h.remarks}</p>
                                        \${performerHtml}
                                    </div>
                                </div>
                            `;
                                    container.innerHTML += item;
                                });
                            }
                        } catch (error) {
                            container.innerHTML = '<p class="text-center py-10 text-xs font-bold text-rose-500">Error fetching logs.</p>';
                        }
                    }

                    function closeFlowModal() {
                        document.getElementById('flowModal').classList.add('hidden');
                    }

                </script>
            </body>

            </html>