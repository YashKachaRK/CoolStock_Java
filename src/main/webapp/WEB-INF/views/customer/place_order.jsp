<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Place Bulk Order | CoolStock</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; }
        .animate-bounce-short { animation: bounce 1s ease-in-out 1; }
        @keyframes bounce { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-10px); } }
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
            <a href="orders" class="text-purple-600 border-b-2 border-purple-600 pb-1">📦 Place Order</a>
            <a href="track" class="text-gray-400 hover:text-purple-600 transition">📍 Track Orders</a>
            <a href="profile" class="text-gray-400 hover:text-purple-600 transition">👤 My Profile</a>
        </div>
        <a href="${pageContext.request.contextPath}/logout"
            class="bg-red-50 text-red-600 px-5 py-2.5 rounded-2xl font-black text-xs hover:bg-red-100 transition uppercase tracking-widest border border-red-100">
            🚪 Logout
        </a>
    </nav>

    <div class="max-w-6xl mx-auto px-6 py-8">

        <!-- Header -->
        <div class="bg-gradient-to-r from-purple-600 to-pink-500 text-white p-8 rounded-[2rem] mb-8 shadow-2xl flex justify-between items-center">
            <div>
                <h1 class="text-4xl font-black tracking-tight">📦 Place Bulk Order</h1>
                <p class="opacity-90 mt-1 font-medium italic">Fresh inventory for your shop. Delivered with care.</p>
            </div>
            <div class="flex gap-3">
                <div class="relative">
                    <span class="absolute left-4 top-1/2 -translate-y-1/2 opacity-50 text-xs text-gray-800">🔍</span>
                    <input id="pSearch" type="text" placeholder="Search..." oninput="filterProducts()" 
                           class="bg-white/10 border border-white/20 text-white placeholder-white/50 rounded-2xl px-10 py-3 text-sm outline-none focus:bg-white/20 w-48 transition-all">
                </div>
                <select id="catFilter" onchange="filterProducts()" 
                        class="bg-white/10 border border-white/20 text-white rounded-2xl px-4 py-3 text-sm outline-none focus:bg-white/20 cursor-pointer">
                    <option value="all" class="text-gray-800">All Categories</option>
                    <option value="Tubs" class="text-gray-800">Tubs</option>
                    <option value="Cones" class="text-gray-800">Cones</option>
                    <option value="Sticks" class="text-gray-800">Sticks</option>
                    <option value="Cups" class="text-gray-800">Cups</option>
                </select>
            </div>
        </div>

        <div class="grid grid-cols-3 gap-8">

            <!-- Product Table -->
            <div class="col-span-2">
                <div class="bg-white rounded-[2rem] shadow-xl border border-gray-100 overflow-hidden">
                    <table class="w-full text-left">
                        <thead class="bg-gray-50/50 border-b border-gray-100 text-[10px] uppercase font-black text-gray-400 tracking-[0.2em] px-6">
                            <tr>
                                <th class="px-8 py-5">Product Details</th>
                                <th class="px-8 py-5">Price</th>
                                <th class="px-8 py-5">Availability</th>
                                <th class="px-8 py-5 text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody id="productTable">
                            <c:forEach var="p" items="${productsList}">
                                <tr class="product-row border-b border-gray-50 hover:bg-purple-50/30 transition-all duration-300" 
                                    data-name="${p.name.toLowerCase()}" 
                                    data-cat="${p.category}">
                                    <td class="px-8 py-6">
                                        <p class="font-black text-gray-800 text-lg tracking-tight">${p.name}</p>
                                        <p class="text-[10px] text-purple-400 font-black uppercase tracking-widest mt-0.5">${p.category} • ${p.flavor}</p>
                                    </td>
                                    <td class="px-8 py-6 font-black text-purple-600 font-mono text-lg">₹${p.price}</td>
                                    <td class="px-8 py-6">
                                        <span class="px-3 py-1.5 rounded-xl text-[10px] font-black uppercase tracking-wider ${p.stock < 10 ? 'bg-red-50 text-red-500 border border-red-100' : 'bg-green-50 text-green-500 border border-green-100'}">
                                            ${p.stock} Units left
                                        </span>
                                    </td>
                                    <td class="px-8 py-6">
                                        <div class="flex items-center justify-center gap-3 bg-gray-50 rounded-2xl p-1.5 w-fit mx-auto border border-gray-100 shadow-inner">
                                            <button onclick="changeQty(${p.id}, -1, ${p.price}, '${p.name}', ${p.stock})" class="w-8 h-8 flex items-center justify-center bg-white border border-gray-200 rounded-xl font-bold hover:bg-red-500 hover:text-white hover:border-red-500 transition-all shadow-sm text-lg">−</button>
                                            <input type="text" id="qty-${p.id}" value="0" readonly class="w-8 text-center font-black text-gray-900 bg-transparent text-sm focus:outline-none">
                                            <button onclick="changeQty(${p.id}, 1, ${p.price}, '${p.name}', ${p.stock})" class="w-8 h-8 flex items-center justify-center bg-white border border-gray-200 rounded-xl font-bold hover:bg-green-500 hover:text-white hover:border-green-500 transition-all shadow-sm text-lg">+</button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Sidebar Summary -->
            <div class="space-y-6">
                <div class="bg-white rounded-[2rem] shadow-2xl p-8 sticky top-24 border border-gray-100 overflow-hidden relative">
                    <div class="absolute top-0 right-0 w-32 h-32 bg-purple-100/50 rounded-full -mr-16 -mt-16 blur-3xl"></div>
                    
                    <h2 class="text-2xl font-black text-gray-800 mb-6 tracking-tight flex items-center gap-2">
                        <span>📋</span> Order Summary
                    </h2>
                    
                    <div id="summaryLines" class="space-y-4 text-sm text-gray-600 mb-8 min-h-[100px] max-h-64 overflow-y-auto pr-2 custom-scrollbar">
                        <p class="text-gray-300 italic text-center py-8">Select products to begin...</p>
                    </div>

                    <div class="border-t border-dashed border-gray-200 pt-6 space-y-3">
                        <div class="flex justify-between text-sm text-gray-400 font-bold uppercase tracking-widest text-[10px]">
                            <span>Subtotal</span>
                            <span id="subtotal">₹0</span>
                        </div>
                        <div class="flex justify-between text-green-500 font-black uppercase tracking-[0.2em] text-[10px]">
                            <span>Delivery Fee</span>
                            <span>FREE</span>
                        </div>
                        <div class="flex justify-between font-black text-3xl pt-4 mt-2 text-gray-900 font-mono tracking-tighter">
                            <span>Total</span>
                            <span class="text-transparent bg-clip-text bg-gradient-to-r from-purple-700 to-pink-600" id="total">₹0</span>
                        </div>
                    </div>

                    <div class="mt-8 space-y-5">
                        <div>
                            <label class="block text-[10px] font-black text-gray-400 uppercase tracking-widest mb-2 ml-1">Delivery Priority</label>
                            <select id="orderUrgency"
                                class="w-full border-2 border-gray-50 rounded-2xl px-5 py-3.5 text-sm font-black focus:border-purple-400 outline-none bg-gray-50/50 transition-all cursor-pointer hover:bg-white shadow-inner">
                                <option value="Regular">Regular (1-2 Days)</option>
                                <option value="Urgent">Urgent (Tomorrow)</option>
                                <option value="Very Urgent">Very Urgent (Today)</option>
                            </select>
                        </div>
                        <div class="bg-gray-900 border border-gray-800 p-6 rounded-[1.5rem] shadow-2xl">
                            <p class="text-[9px] text-purple-400 font-black uppercase tracking-widest mb-3">Store Context</p>
                            <p class="text-sm font-black text-white tracking-tight underline decoration-purple-500 underline-offset-4">${customer.shopName}</p>
                            <p class="text-[11px] text-gray-400 mt-2 font-medium opacity-80 leading-relaxed">${customer.area}, ${customer.city}</p>
                            <p class="text-[11px] text-purple-300 font-mono mt-2 font-black">📞 ${customer.phone}</p>
                        </div>
                    </div>

                    <button onclick="placeOrder()"
                        class="mt-8 w-full py-5 bg-gradient-to-r from-purple-600 to-pink-500 text-white font-black rounded-[1.25rem] hover:opacity-90 hover:scale-[1.02] active:scale-[0.98] transition-all duration-300 shadow-xl shadow-purple-200 text-sm tracking-widest">
                        🚀 CONFIRM BULK ORDER
                    </button>
                    <p class="text-center text-[9px] text-gray-400 mt-4 font-black uppercase tracking-[0.3em]">Payment: Cash on Delivery</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Success Modal -->
    <div id="successModal" class="hidden fixed inset-0 bg-gray-900/80 backdrop-blur-md flex items-center justify-center z-50 p-4">
        <div class="bg-white rounded-[3rem] shadow-2xl w-full max-w-sm p-12 text-center relative overflow-hidden">
            <div class="absolute -top-10 -left-10 w-40 h-40 bg-purple-100 rounded-full blur-3xl opacity-50"></div>
            <div class="text-9xl mb-8 relative">🎉</div>
            <h2 class="text-3xl font-black text-gray-900 mb-3 tracking-tighter">Order Placed!</h2>
            <p class="text-gray-500 text-sm font-medium leading-relaxed px-2">Your fresh stock has been locked. Check progress in tracking.</p>
            <div class="bg-purple-50 border border-purple-100 rounded-3xl p-6 my-10 group transition-all hover:bg-purple-100">
                <p class="text-[10px] text-purple-400 font-black uppercase tracking-[0.2em] mb-2">Tracking Passport</p>
                <p class="font-black text-purple-700 text-3xl font-mono tracking-tighter" id="newOrderId"></p>
            </div>
            <a href="track"
                class="block w-full py-5 bg-gray-900 text-white font-black rounded-2xl hover:bg-black transition-all shadow-2xl shadow-gray-200">
                📍 TRACK JOURNEY
            </a>
        </div>
    </div>

    <script>
        const cart = {};
        
        function changeQty(id, delta, price, name, stock) {
            if (!cart[id]) cart[id] = { qty: 0, price: price, name: name };
            const newQty = cart[id].qty + delta;
            if (newQty < 0) return;
            if (newQty > stock) {
                alert('⚠️ STOCK LIMIT: ' + name + ' is capped at ' + stock + ' units.');
                return;
            }
            cart[id].qty = newQty;
            document.getElementById('qty-' + id).value = newQty;
            updateSummary();
        }

        function updateSummary() {
            const lines = document.getElementById('summaryLines');
            let subtotal = 0, html = '';
            for (const [id, item] of Object.entries(cart)) {
                if (item.qty > 0) {
                    const lineTotal = item.qty * item.price;
                    subtotal += lineTotal;
                    html += `<div class="flex justify-between items-center group">
                                <span class="font-bold text-gray-700 text-sm italic group-hover:text-purple-600 transition-colors">${item.name} <span class="text-[10px] text-gray-400 block not-italic uppercase tracking-widest font-black">× ${item.qty} cartons</span></span>
                                <span class="font-black text-gray-900 font-mono tracking-tighter">₹${lineTotal.toLocaleString('en-IN')}</span>
                            </div>`;
                }
            }
            lines.innerHTML = html || '<p class="text-gray-300 italic text-center py-8">Select products to begin...</p>';
            document.getElementById('subtotal').innerText = '₹' + subtotal.toLocaleString('en-IN');
            document.getElementById('total').innerText = '₹' + subtotal.toLocaleString('en-IN');
        }

        function filterProducts() {
            const q = document.getElementById('pSearch').value.toLowerCase();
            const cat = document.getElementById('catFilter').value;
            document.querySelectorAll('.product-row').forEach(row => {
                const name = row.getAttribute('data-name');
                const rowCat = row.getAttribute('data-cat');
                row.style.display = (name.includes(q) && (cat === 'all' || rowCat === cat)) ? '' : 'none';
            });
        }

        function placeOrder() {
            const hasItems = Object.values(cart).some(i => i.qty > 0);
            if (!hasItems) { alert('⚠️ Basket is empty!'); return; }

            const params = new URLSearchParams();
            for (const [id, item] of Object.entries(cart)) {
                if (item.qty > 0) params.append('qty_' + id, item.qty);
            }
            params.append('urgency', document.getElementById('orderUrgency').value);

            fetch('${pageContext.request.contextPath}/customer/placeOrder', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            })
            .then(res => res.text())
            .then(text => {
                if (text.startsWith('Success:')) {
                    document.getElementById('newOrderId').innerText = text.split(':')[1];
                    document.getElementById('successModal').classList.remove('hidden');
                } else alert(text);
            });
        }
    </script>
</body>
</html>