<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Inventory Management | CoolStock Manager</title>
                <script src="https://cdn.tailwindcss.com"></script>
                <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <style>
                    body {
                        font-family: 'Outfit', sans-serif;
                    }

                    @keyframes fadeInUp {
                        from {
                            opacity: 0;
                            transform: translateY(16px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    .fade-in {
                        animation: fadeInUp 0.35s ease forwards;
                    }

                    @keyframes modalIn {
                        from {
                            opacity: 0;
                            transform: scale(0.95) translateY(-10px);
                        }

                        to {
                            opacity: 1;
                            transform: scale(1) translateY(0);
                        }
                    }

                    .modal-box {
                        animation: modalIn 0.25s ease forwards;
                    }

                    tr.product-row:hover td {
                        background: #f8faff;
                    }
                </style>
            </head>

            <body class="bg-gray-100 min-h-screen">
                <div class="flex">

                    <%@ include file="sidebar.jsp" %>

                        <div class="ml-64 p-8 w-full">

                            <!-- Header -->
                            <div
                                class="bg-gradient-to-r from-blue-700 to-cyan-600 text-white p-7 rounded-2xl mb-8 shadow-lg">
                                <div class="flex justify-between items-center">
                                    <div>
                                        <h1 class="text-3xl font-black">Inventory Control</h1>
                                        <p class="opacity-75 mt-1 text-sm">Manager Operations Dashboard — Secure SKU
                                            Registry</p>
                                    </div>
                                    <div class="flex gap-3">
                                        <button onclick="downloadCSV()"
                                            class="bg-blue-800 text-white font-bold px-5 py-2.5 rounded-xl hover:bg-blue-900 transition shadow-md border border-white/20">
                                            📄 Export CSV
                                        </button>
                                        <button onclick="openModal('addProductModal')"
                                            class="bg-white text-blue-700 font-bold px-6 py-2.5 rounded-xl hover:bg-blue-50 transition shadow-md">
                                            + Commission SKU
                                        </button>
                                    </div>
                                </div>

                                <!-- Stats -->
                                <div class="grid grid-cols-4 gap-4 mt-6">
                                    <div class="bg-white/15 backdrop-blur rounded-xl p-4 text-center">
                                        <p class="text-xs opacity-75 font-semibold uppercase tracking-wide">Registry
                                            Total</p>
                                        <p class="text-3xl font-black mt-1" id="statTotal">${productCount}</p>
                                    </div>
                                    <div class="bg-white/15 backdrop-blur rounded-xl p-4 text-center">
                                        <p class="text-xs opacity-75 font-semibold uppercase tracking-wide">Categories
                                        </p>
                                        <p class="text-3xl font-black mt-1">4</p>
                                    </div>
                                    <div
                                        class="bg-white/15 backdrop-blur rounded-xl p-4 text-center border border-red-300/40">
                                        <p class="text-xs opacity-75 font-semibold uppercase tracking-wide">Alert Levels
                                        </p>
                                        <p class="text-3xl font-black mt-1 text-yellow-300" id="statLow">
                                            ${lowStockCount}</p>
                                    </div>
                                    <div class="bg-white/15 backdrop-blur rounded-xl p-4 text-center">
                                        <p class="text-xs opacity-75 font-semibold uppercase tracking-wide">Active
                                            Selection</p>
                                        <p class="text-3xl font-black mt-1" id="statShowing">0</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Toolbar -->
                            <div class="bg-white rounded-2xl shadow-md p-4 mb-5 flex flex-wrap gap-3 items-center">
                                <div class="relative flex-1 min-w-[200px]">
                                    <input id="searchInput" type="text" placeholder="Filter by name, flavour, or SKU..."
                                        oninput="applyFilters()"
                                        class="w-full px-4 py-2.5 border-2 border-gray-100 rounded-xl text-sm focus:outline-none focus:border-blue-500 transition">
                                </div>

                                <select id="catFilter" onchange="applyFilters()"
                                    class="border-2 border-gray-100 rounded-xl px-4 py-2.5 text-sm font-semibold focus:outline-none focus:border-blue-500 bg-white cursor-pointer">
                                    <option value="all">All Categories</option>
                                    <option value="Tubs">Tubs</option>
                                    <option value="Cones">Cones</option>
                                    <option value="Sticks">Sticks</option>
                                    <option value="Cups">Cups</option>
                                </select>

                                <select id="stockFilter" onchange="applyFilters()"
                                    class="border-2 border-gray-100 rounded-xl px-4 py-2.5 text-sm font-semibold focus:outline-none focus:border-blue-500 bg-white cursor-pointer">
                                    <option value="all">All Stock Status</option>
                                    <option value="low">Low Level (&lt;10)</option>
                                    <option value="ok">Healthy Level</option>
                                </select>

                                <select id="sortSelect" onchange="applyFilters()"
                                    class="border-2 border-gray-100 rounded-xl px-4 py-2.5 text-sm font-semibold focus:outline-none focus:border-blue-500 bg-white cursor-pointer">
                                    <option value="az">Sort: A to Z</option>
                                    <option value="za">Sort: Z to A</option>
                                    <option value="price-asc">Price: Ascending</option>
                                    <option value="price-desc">Price: Descending</option>
                                    <option value="stock-asc">Stock: Ascending</option>
                                    <option value="stock-desc">Stock: Descending</option>
                                </select>

                                <button onclick="resetFilters()"
                                    class="border-2 border-gray-100 rounded-xl px-4 py-2.5 text-sm font-semibold text-gray-500 hover:border-red-300 hover:text-red-500 transition">
                                    Clear
                                </button>
                            </div>

                            <!-- Table -->
                            <div class="bg-white rounded-2xl shadow-md overflow-hidden">
                                <div class="overflow-x-auto">
                                    <table class="w-full text-sm">
                                        <thead class="bg-gray-50 border-b-2 border-gray-100">
                                            <tr class="text-xs text-gray-500 uppercase tracking-wider font-bold">
                                                <th class="py-4 px-5 text-left">Product</th>
                                                <th class="py-4 px-5 text-left">Category</th>
                                                <th class="py-4 px-5 text-right">Unit Price</th>
                                                <th class="py-4 px-5 text-right">In Stock</th>
                                                <th class="py-4 px-5 text-center" style="width: 200px;">Quick Add (+
                                                    Amt)</th>
                                                <th class="py-4 px-5 text-center">Operations</th>
                                            </tr>
                                        </thead>
                                        <tbody id="productTableBody">
                                            <c:forEach var="p" items="${productsList}">
                                                <tr class="product-row border-b border-gray-100 fade-in ${p.stock < 10 ? 'bg-red-50' : ''}"
                                                    data-name="${p.name.toLowerCase()}" data-category="${p.category}"
                                                    data-flavor="${p.flavor.toLowerCase()}" data-price="${p.price}"
                                                    data-stock="${p.stock}" data-sku="${p.productCode.toLowerCase()}">
                                                    <td class="py-3.5 px-5">
                                                        <p class="font-bold text-gray-800 text-sm leading-tight">
                                                            ${p.name}</p>
                                                        <p
                                                            class="text-xs text-gray-400 mt-0.5 font-medium uppercase tracking-widest">
                                                            ${p.productCode}</p>
                                                    </td>
                                                    <td class="py-3.5 px-5">
                                                        <span
                                                            class="inline-block px-2.5 py-0.5 rounded-full text-[10px] font-bold 
                                        ${p.category == 'Tubs' ? 'bg-indigo-100 text-indigo-700' : (p.category == 'Cones' ? 'bg-blue-100 text-blue-700' : 'bg-green-100 text-green-700')}">
                                                            ${p.category}
                                                        </span>
                                                    </td>
                                                    <td class="py-3.5 px-5 text-right font-black text-blue-700">
                                                        ₹${p.price}</td>
                                                    <td class="py-3.5 px-5 text-right">
                                                        <span
                                                            class="font-bold ${p.stock < 10 ? 'text-red-600' : 'text-gray-700'}">${p.stock}</span>
                                                        <span class="text-gray-400 text-[10px] ml-1">UNITS</span>
                                                    </td>
                                                    <td class="py-3.5 px-5 text-center">
                                                        <div class="flex flex-col gap-1.5 items-center justify-center">
                                                            <div class="flex items-center gap-1.5">
                                                                <input type="number" id="restock-input-${p.id}"
                                                                    value="0" min="1"
                                                                    class="w-16 px-2 py-1.5 border-2 border-gray-200 rounded-lg text-center text-xs focus:ring-1 focus:ring-blue-500 outline-none font-bold">
                                                                <button
                                                                    onclick="handleQuickRestockAction(${p.id}, '${p.name}')"
                                                                    class="bg-emerald-600 hover:bg-emerald-700 text-white px-2.5 py-1.5 rounded-lg font-bold text-[10px] uppercase transition shadow-sm">
                                                                    Add
                                                                </button>
                                                            </div>
                                                            <input type="date" id="restock-date-${p.id}"
                                                                class="w-full px-2 py-1 border border-gray-200 rounded text-[10px] focus:outline-none focus:border-blue-400">
                                                        </div>
                                                    </td>
                                                    <td class="py-3.5 px-5 font-bold">
                                                        <div class="flex gap-2 justify-center">
                                                            <button data-code="${p.productCode}"
                                                                data-name='<c:out value="${p.name}" />'
                                                                data-category="${p.category}"
                                                                data-flavor='<c:out value="${p.flavor}" />'
                                                                data-price="${p.price}" data-stock="${p.stock}"
                                                                data-pcs="${p.pcsPerBox}"
                                                                data-desc='<c:out value="${p.description}" />'
                                                                onclick="openEditModalFromBtn(this)"
                                                                class="bg-blue-50 text-blue-700 hover:bg-blue-600 hover:text-white px-4 py-1.5 rounded-lg text-xs font-bold transition">Edit</button>

                                                            <form
                                                                action="${pageContext.request.contextPath}/manager/products/delete"
                                                                method="post"
                                                                onsubmit="return confirm('Confirm SKU Deletion?')">
                                                                <input type="hidden" name="code"
                                                                    value="${p.productCode}">
                                                                <button type="submit"
                                                                    class="bg-red-50 text-red-600 hover:bg-red-600 hover:text-white px-4 py-1.5 rounded-lg text-xs font-bold transition">Delete</button>
                                                            </form>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                <div id="emptyState" class="hidden py-16 text-center text-gray-400">
                                    <p class="font-semibold text-lg">Inventory search returned no results</p>
                                </div>
                            </div>

                        </div>
                </div>

                <!-- Add Modal -->
                <div id="addProductModal"
                    class="hidden fixed inset-0 bg-black/60 backdrop-blur-sm z-[100] flex items-center justify-center p-4">
                    <div class="modal-box bg-white rounded-[2rem] w-full max-w-lg overflow-hidden shadow-2xl">
                        <div
                            class="flex justify-between items-center p-7 border-b bg-gradient-to-r from-blue-700 to-cyan-600 text-white">
                            <h2 class="text-2xl font-black">Commission New SKU</h2>
                            <button onclick="closeModal('addProductModal')"
                                class="text-white/70 hover:text-white text-3xl font-light">&times;</button>
                        </div>
                        <form action="${pageContext.request.contextPath}/manager/products/add" method="post"
                            class="p-8 grid grid-cols-2 gap-5">
                            <div class="col-span-2">
                                <label
                                    class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-1.5 ml-1">Product
                                    Name</label>
                                <input type="text" name="name" required
                                    class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-5 py-3 text-sm font-semibold focus:bg-white focus:border-blue-500 transition-all outline-none">
                            </div>
                            <div>
                                <label
                                    class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-1.5 ml-1">Category</label>
                                <select name="category" required
                                    class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-5 py-3 text-sm font-black focus:bg-white focus:border-blue-500 transition-all outline-none cursor-pointer">
                                    <option value="Tubs">Tubs</option>
                                    <option value="Cones">Cones</option>
                                    <option value="Sticks">Sticks</option>
                                    <option value="Cups">Cups</option>
                                </select>
                            </div>
                            <div>
                                <label
                                    class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-1.5 ml-1">Flavor</label>
                                <input type="text" name="flavor" required
                                    class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-5 py-3 text-sm font-semibold focus:bg-white focus:border-blue-500 transition-all outline-none">
                            </div>
                            <div>
                                <label
                                    class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-1.5 ml-1">Unit
                                    Price ($)</label>
                                <input type="number" name="price" step="0.01" required
                                    class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-5 py-3 text-sm font-black focus:bg-white focus:border-blue-500 transition-all outline-none">
                            </div>
                            <div>
                                <label
                                    class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-1.5 ml-1">Initial
                                    Stock Units</label>
                                <input type="number" name="stock" required
                                    class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-5 py-3 text-sm font-black focus:bg-white focus:border-blue-500 transition-all outline-none">
                            </div>
                            <div>
                                <label
                                    class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-1.5 ml-1">Expiry
                                    Date</label>
                                <input type="date" name="expiryDate" required
                                    class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-5 py-3 text-sm font-black focus:bg-white focus:border-blue-500 transition-all outline-none">
                            </div>
                            <div class="col-span-2">
                                <label
                                    class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-1.5 ml-1">SKU
                                    Description</label>
                                <textarea name="description" rows="2"
                                    class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-5 py-3 text-sm font-semibold focus:bg-white focus:border-blue-500 transition-all outline-none resize-none"></textarea>
                            </div>
                            <input type="hidden" name="pcsPerBox" value="1">
                            <div class="col-span-2 pt-4 flex gap-4">
                                <button type="button" onclick="closeModal('addProductModal')"
                                    class="flex-1 py-4 text-gray-500 font-black uppercase text-xs hover:bg-gray-100 rounded-2xl transition">Cancel</button>
                                <button type="submit"
                                    class="flex-1 py-4 bg-gray-900 text-white font-black rounded-2xl hover:bg-black transition shadow-xl text-xs uppercase tracking-widest">Register
                                    SKU</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Edit Modal -->
                <div id="editProductModal"
                    class="hidden fixed inset-0 bg-black/60 backdrop-blur-sm z-[100] flex items-center justify-center p-4">
                    <div class="modal-box bg-white rounded-[2rem] w-full max-w-lg overflow-hidden shadow-2xl">
                        <div
                            class="flex justify-between items-center p-7 border-b bg-gradient-to-r from-blue-900 to-indigo-800 text-white">
                            <h2 class="text-2xl font-black">Edit SKU Attributes</h2>
                            <button onclick="closeModal('editProductModal')"
                                class="text-white/70 hover:text-white text-3xl font-light">&times;</button>
                        </div>
                        <form action="${pageContext.request.contextPath}/manager/products/edit" method="post"
                            class="p-8 grid grid-cols-2 gap-5">
                            <input type="hidden" name="productCode" id="editProductCode">
                            <div class="col-span-2">
                                <label
                                    class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-1.5 ml-1">Name</label>
                                <input type="text" name="name" id="editName" required
                                    class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-5 py-3 text-sm font-semibold focus:bg-white focus:border-blue-500 transition-all outline-none">
                            </div>
                            <div>
                                <label
                                    class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-1.5 ml-1">Category</label>
                                <select name="category" id="editCategory" required
                                    class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-5 py-3 text-sm font-black focus:bg-white focus:border-blue-500 transition-all outline-none">
                                    <option value="Tubs">Tubs</option>
                                    <option value="Cones">Cones</option>
                                    <option value="Sticks">Sticks</option>
                                    <option value="Cups">Cups</option>
                                </select>
                            </div>
                            <div>
                                <label
                                    class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-1.5 ml-1">Flavour</label>
                                <input type="text" name="flavor" id="editFlavor" required
                                    class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-5 py-3 text-sm font-semibold focus:bg-white focus:border-blue-500 transition-all outline-none">
                            </div>
                            <div>
                                <label
                                    class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-1.5 ml-1">Price
                                    (₹)</label>
                                <input type="number" name="price" id="editPrice" step="0.01" required
                                    class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-5 py-3 text-sm font-black focus:bg-white focus:border-blue-500 transition-all outline-none">
                            </div>
                            <div>
                                <label
                                    class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-1.5 ml-1">In
                                    Stock</label>
                                <input type="number" name="stock" id="editStock" required
                                    class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-5 py-3 text-sm font-black focus:bg-white focus:border-blue-500 transition-all outline-none">
                            </div>
                            <div class="col-span-2">
                                <label
                                    class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-1.5 ml-1">Description</label>
                                <textarea name="description" id="editDescription" rows="2"
                                    class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-5 py-3 text-sm font-semibold focus:bg-white focus:border-blue-500 transition-all outline-none resize-none"></textarea>
                            </div>
                            <input type="hidden" name="pcsPerBox" id="editPcsPerBox">
                            <div class="col-span-2 pt-4 flex gap-4">
                                <button type="button" onclick="closeModal('editProductModal')"
                                    class="flex-1 py-4 text-gray-500 font-black uppercase text-xs hover:bg-gray-100 rounded-2xl transition">Discard</button>
                                <button type="submit"
                                    class="flex-1 py-4 bg-indigo-600 text-white font-black rounded-2xl hover:bg-indigo-700 transition shadow-xl text-xs uppercase tracking-widest">Update
                                    SKU</button>
                            </div>
                        </form>
                    </div>
                </div>

                <script>
                    function downloadCSV() {
                        let csvContent = "data:text/csv;charset=utf-8,SKU,Name,Category,Price,Stock\n";
                        document.querySelectorAll('.product-row').forEach(r => {
                            csvContent += r.getAttribute('data-sku') + "," + r.getAttribute('data-name') + "," +
                                r.getAttribute('data-category') + "," + r.getAttribute('data-price') + "," +
                                r.getAttribute('data-stock') + "\n";
                        });
                        const encodedUri = encodeURI(csvContent);
                        const link = document.createElement("a");
                        link.setAttribute("href", encodedUri);
                        link.setAttribute("download", "internal_inventory_report.csv");
                        document.body.appendChild(link);
                        link.click();
                        document.body.removeChild(link);
                    }

                    function applyFilters() {
                        const q = document.getElementById('searchInput').value.toLowerCase();
                        const cat = document.getElementById('catFilter').value;
                        const stock = document.getElementById('stockFilter').value;
                        const sort = document.getElementById('sortSelect').value;

                        const rows = Array.from(document.querySelectorAll('.product-row'));
                        let visibleCount = 0;

                        rows.forEach(r => {
                            const pName = r.getAttribute('data-name');
                            const pCat = r.getAttribute('data-category');
                            const pFlav = r.getAttribute('data-flavor');
                            const pSku = r.getAttribute('data-sku');
                            const pStock = parseInt(r.getAttribute('data-stock'));

                            const matchQ = (pName + ' ' + pFlav + ' ' + pCat + ' ' + pSku).includes(q);
                            const matchCat = cat === 'all' || pCat === cat;
                            const matchSt = stock === 'all' || (stock === 'low' ? pStock < 10 : pStock >= 10);

                            if (matchQ && matchCat && matchSt) {
                                r.style.display = '';
                                visibleCount++;
                            } else {
                                r.style.display = 'none';
                            }
                        });

                        document.getElementById('emptyState').classList.toggle('hidden', visibleCount > 0);
                        document.getElementById('statShowing').innerText = visibleCount;

                        const tbody = document.getElementById('productTableBody');
                        rows.sort((a, b) => {
                            if (sort === 'az') return a.getAttribute('data-name').localeCompare(b.getAttribute('data-name'));
                            if (sort === 'za') return b.getAttribute('data-name').localeCompare(a.getAttribute('data-name'));
                            if (sort === 'price-asc') return parseFloat(a.getAttribute('data-price')) - parseFloat(b.getAttribute('data-price'));
                            if (sort === 'price-desc') return parseFloat(b.getAttribute('data-price')) - parseFloat(a.getAttribute('data-price'));
                            if (sort === 'stock-asc') return parseInt(a.getAttribute('data-stock')) - parseInt(b.getAttribute('data-stock'));
                            if (sort === 'stock-desc') return parseInt(b.getAttribute('data-stock')) - parseInt(a.getAttribute('data-stock'));
                            return 0;
                        }).forEach(r => tbody.appendChild(r));
                    }

                    function resetFilters() {
                        document.getElementById('searchInput').value = '';
                        document.getElementById('catFilter').value = 'all';
                        document.getElementById('stockFilter').value = 'all';
                        document.getElementById('sortSelect').value = 'az';
                        applyFilters();
                    }

                    function openModal(id) { document.getElementById(id).classList.remove('hidden'); }
                    function closeModal(id) { document.getElementById(id).classList.add('hidden'); }

                    function openEditModalFromBtn(btn) {
                        document.getElementById('editProductCode').value = btn.dataset.code;
                        document.getElementById('editName').value = btn.dataset.name;
                        document.getElementById('editCategory').value = btn.dataset.category;
                        document.getElementById('editFlavor').value = btn.dataset.flavor;
                        document.getElementById('editPrice').value = btn.dataset.price;
                        document.getElementById('editStock').value = btn.dataset.stock;
                        document.getElementById('editPcsPerBox').value = btn.dataset.pcs;
                        document.getElementById('editDescription').value = btn.dataset.desc;
                        openModal('editProductModal');
                    }

                    function handleQuickRestockAction(id, name) {
                        const amountField = document.getElementById('restock-input-' + id);
                        const dateField = document.getElementById('restock-date-' + id);
                        const amount = parseInt(amountField.value);
                        const expiryDate = dateField.value;

                        if (amount <= 0 || isNaN(amount)) { alert('Enter a valid increment.'); return; }
                        if (!expiryDate) { alert('Please select an expiry date for this batch.'); return; }

                        fetch('${pageContext.request.contextPath}/manager/products/quickRestock', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'id=' + id + '&amount=' + amount + '&expiryDate=' + expiryDate
                        })
                            .then(res => res.text())
                            .then(text => {
                                if (text === 'Success') location.reload();
                                else alert(text);
                            });
                    }

                    applyFilters();
                </script>
            </body>

            </html>