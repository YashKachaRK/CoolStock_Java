<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products | CoolStock Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .fade-in { animation: fadeInUp 0.35s ease forwards; }

        @keyframes modalIn {
            from { opacity: 0; transform: scale(0.95) translateY(-10px); }
            to   { opacity: 1; transform: scale(1) translateY(0); }
        }
        .modal-box { animation: modalIn 0.25s ease forwards; }

        tr.product-row:hover td { background: #f8faff; }

        /* Toast */
        #toast { transition: all 0.3s ease; }
    </style>
</head>
<body class="bg-gray-100 min-h-screen">
<div class="flex">

    <%@ include file="sidebar.jsp" %>

    <div class="ml-64 p-8 w-full">

        <div class="bg-gradient-to-r from-blue-700 to-cyan-600 text-white p-7 rounded-2xl mb-8 shadow-lg">
            <div class="flex justify-between items-center">
                <div>
                    <h1 class="text-3xl font-black">Manage Products</h1>
                    <p class="opacity-75 mt-1 text-sm">Ice cream inventory — sorted A to Z by default</p>
                </div>
                <div class="flex gap-3">
                    <button onclick="downloadCSV()"
                        class="bg-blue-800 text-white font-bold px-5 py-2.5 rounded-xl hover:bg-blue-900 transition shadow-md border border-white/20">
                        📄 Download CSV
                    </button>
                    <button onclick="downloadPDF()"
                        class="bg-white text-blue-700 font-bold px-5 py-2.5 rounded-xl hover:bg-blue-50 transition shadow-md">
                        📥 Download PDF
                    </button>
                </div>
            </div>

            <!-- ── Stats row ── -->
            <div class="grid grid-cols-4 gap-4 mt-6">
                <div class="bg-white/15 backdrop-blur rounded-xl p-4 text-center">
                    <p class="text-xs opacity-75 font-semibold uppercase tracking-wide">Total Products</p>
                    <p class="text-3xl font-black mt-1" id="statTotal">0</p>
                </div>
                <div class="bg-white/15 backdrop-blur rounded-xl p-4 text-center">
                    <p class="text-xs opacity-75 font-semibold uppercase tracking-wide">Categories</p>
                    <p class="text-3xl font-black mt-1">3</p>
                </div>
                <div class="bg-white/15 backdrop-blur rounded-xl p-4 text-center border border-red-300/40">
                    <p class="text-xs opacity-75 font-semibold uppercase tracking-wide">Low Stock</p>
                    <p class="text-3xl font-black mt-1 text-yellow-300" id="statLow">0</p>
                </div>
                <div class="bg-white/15 backdrop-blur rounded-xl p-4 text-center">
                    <p class="text-xs opacity-75 font-semibold uppercase tracking-wide">Showing</p>
                    <p class="text-3xl font-black mt-1" id="statShowing">0</p>
                </div>
            </div>
        </div>

        <!-- ── Toolbar: Search + Filters + Sort ────────────────────────── -->
        <div class="bg-white rounded-2xl shadow-md p-4 mb-5 flex flex-wrap gap-3 items-center">

            <!-- Search -->
            <div class="relative flex-1 min-w-[200px]">
                <input id="searchInput" type="text" placeholder="Search product, flavour..."
                    oninput="applyFilters()"
                    class="w-full px-4 py-2.5 border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-blue-500 transition">
            </div>

            <!-- Category filter -->
            <select id="catFilter" onchange="applyFilters()"
                class="border-2 border-gray-200 rounded-xl px-4 py-2.5 text-sm font-semibold focus:outline-none focus:border-blue-500 bg-white transition">
                <option value="all">All Categories</option>
                <option value="Tubs">Tubs</option>
                <option value="Cones">Cones</option>
                <option value="Sticks">Sticks</option>
            </select>

            <!-- Stock filter -->
            <select id="stockFilter" onchange="applyFilters()"
                class="border-2 border-gray-200 rounded-xl px-4 py-2.5 text-sm font-semibold focus:outline-none focus:border-blue-500 bg-white transition">
                <option value="all">All Stock</option>
                <option value="low">Low Stock (&lt;50)</option>
                <option value="ok">In Stock (>=50)</option>
            </select>

            <!-- Sort -->
            <select id="sortSelect" onchange="applyFilters()"
                class="border-2 border-gray-200 rounded-xl px-4 py-2.5 text-sm font-semibold focus:outline-none focus:border-blue-500 bg-white transition">
                <option value="az">A → Z</option>
                <option value="za">Z → A</option>
                <option value="price-asc">Price ↑</option>
                <option value="price-desc">Price ↓</option>
                <option value="stock-asc">Stock ↑</option>
                <option value="stock-desc">Stock ↓</option>
            </select>

            <!-- Reset -->
            <button onclick="resetFilters()"
                class="border-2 border-gray-200 rounded-xl px-4 py-2.5 text-sm font-semibold text-gray-500 hover:border-red-300 hover:text-red-500 transition">
                Reset
            </button>
        </div>

        <!-- ── Products Table ──────────────────────────────────────────── -->
        <div class="bg-white rounded-2xl shadow-md overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-sm">
                    <thead class="bg-gray-50 border-b-2 border-gray-100">
                        <tr class="text-xs text-gray-500 uppercase tracking-wider font-bold">
                            <th class="py-4 px-5 text-left">#</th>
                            <th class="py-4 px-5 text-left">Product</th>
                            <th class="py-4 px-5 text-left">Category</th>
                            <th class="py-4 px-5 text-left">Flavour</th>
                            <th class="py-4 px-5 text-left">Unit Price</th>
                            <th class="py-4 px-5 text-left">Pcs / Box</th>
                            <th class="py-4 px-5 text-left">Stock</th>
                            <th class="py-4 px-5 text-left">Status</th>
                            <th class="py-4 px-5 text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="productTableBody">
                        <c:forEach var="p" items="${productsList}" varStatus="loop">
                            <tr class="product-row border-b border-gray-100 fade-in ${p.stock < 50 ? 'bg-red-50' : ''}" 
                                data-name="${p.name.toLowerCase()}" 
                                data-category="${p.category}" 
                                data-flavor="${p.flavor.toLowerCase()}" 
                                data-price="${p.price}" 
                                data-stock="${p.stock}"
                                data-pcs="${p.pcsPerBox}"
                                data-desc="${p.description}">
                                <td class="py-3.5 px-5 text-gray-400 text-xs font-bold">${loop.index + 1}</td>
                                <td class="py-3.5 px-5">
                                    <div>
                                        <p class="font-bold text-gray-800 text-sm leading-tight">${p.name}</p>
                                        <p class="text-xs text-gray-400 mt-0.5">${p.productCode}</p>
                                    </div>
                                </td>
                                <td class="py-3.5 px-5">
                                    <span class="inline-block px-2.5 py-0.5 rounded-full text-xs font-bold 
                                        ${p.category == 'Tubs' ? 'bg-yellow-100 text-yellow-700' : (p.category == 'Cones' ? 'bg-blue-100 text-blue-700' : 'bg-green-100 text-green-700')}">
                                        ${p.category}
                                    </span>
                                </td>
                                <td class="py-3.5 px-5 text-gray-600 text-sm">${p.flavor}</td>
                                <td class="py-3.5 px-5 font-black text-blue-700">₹${p.price}</td>
                                <td class="py-3.5 px-5">
                                    <span class="font-bold text-gray-800">${p.pcsPerBox}</span>
                                    <span class="text-gray-400 text-xs ml-1">pcs</span>
                                </td>
                                <td class="py-3.5 px-5">
                                    <span class="font-bold ${p.stock < 50 ? 'text-red-600' : 'text-gray-700'}">${p.stock}</span>
                                    <span class="text-gray-400 text-xs ml-1">units</span>
                                </td>
                                <td class="py-3.5 px-5">
                                    <span class="inline-block px-2.5 py-0.5 rounded-full text-xs font-semibold 
                                        ${p.stock < 50 ? 'bg-red-100 text-red-600 font-bold' : (p.stock < 200 ? 'bg-yellow-100 text-yellow-700' : 'bg-green-100 text-green-700')}">
                                        ${p.stock < 50 ? 'Low Stock' : (p.stock < 200 ? 'Medium' : 'In Stock')}
                                    </span>
                                </td>
                                <td class="py-3.5 px-5">
                                    <div class="flex gap-2 justify-center">
                                        <button onclick="openViewModal(this.closest('tr'))" title="View Details"
                                            class="bg-indigo-50 text-indigo-600 hover:bg-indigo-600 hover:text-white px-4 py-1.5 rounded-lg text-xs font-bold transition">View</button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- Empty state -->
                <div id="emptyState" class="hidden py-20 text-center text-gray-400">
                    <p class="font-semibold text-lg">No products match your filters</p>
                    <p class="text-sm mt-1">Try adjusting your search or filter options.</p>
                </div>
            </div>
        </div>

    </div><!-- /main -->
</div><!-- /flex -->


<!-- ═══════════════════════════════════════════════════════════════════════
     VIEW MODAL
═══════════════════════════════════════════════════════════════════════ -->
<div id="productViewModal" class="hidden fixed inset-0 bg-black/50 z-50 flex items-center justify-center backdrop-blur-sm px-4">
    <div class="modal-box bg-white rounded-2xl shadow-2xl w-full max-w-lg overflow-hidden">
        <div class="flex justify-between items-center p-6 border-b bg-gradient-to-r from-blue-700 to-cyan-600 text-white">
            <h2 class="text-xl font-black" id="modalTitle">View Product</h2>
            <button onclick="closeModal()" class="text-white/70 hover:text-white text-2xl leading-none font-bold">&times;</button>
        </div>
        <div class="p-6 space-y-4">
            <div class="grid grid-cols-2 gap-4">
                <div class="col-span-2">
                    <label class="block text-sm font-bold text-gray-700 mb-1">Product Name</label>
                    <input type="text" id="f_name" readonly
                        class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-4 py-2.5 text-sm transition">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Category</label>
                    <input type="text" id="f_category" readonly
                        class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-4 py-2.5 text-sm transition">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Flavour</label>
                    <input type="text" id="f_flavor" readonly
                        class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-4 py-2.5 text-sm transition">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Unit Price (₹)</label>
                    <input type="text" id="f_price" readonly
                        class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-4 py-2.5 text-sm transition">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Stock (units)</label>
                    <input type="text" id="f_stock" readonly
                        class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-4 py-2.5 text-sm transition">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Pieces per Box</label>
                    <input type="text" id="f_pcsPerBox" readonly
                        class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-4 py-2.5 text-sm transition">
                </div>
                <div class="col-span-2">
                    <label class="block text-sm font-bold text-gray-700 mb-1">Description</label>
                    <textarea id="f_desc" rows="2" readonly
                        class="w-full border-2 border-gray-100 bg-gray-50 rounded-xl px-4 py-2.5 text-sm transition resize-none"></textarea>
                </div>
            </div>
            <div class="flex justify-end gap-3 pt-2 border-t">
                <button type="button" onclick="closeModal()"
                    class="px-5 py-2.5 text-gray-500 font-bold hover:bg-gray-100 rounded-xl transition text-sm">
                    Close
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Toast -->
<div id="toast" class="hidden fixed bottom-6 right-6 z-[100] text-white px-6 py-3 rounded-2xl shadow-2xl font-semibold text-sm"></div>


<!-- ═══════════════════════════════════════════════════════════════════════
     JAVASCRIPT
═══════════════════════════════════════════════════════════════════════ -->
<script>
function downloadCSV() {
    let csvContent = "data:text/csv;charset=utf-8,Product Name,Category,Flavor,Price,Stock,PcsPerBox\n";
    var rows = Array.from(document.querySelectorAll('.product-row'));
    rows.forEach(function(r) {
        let name = r.getAttribute('data-name');
        let cat = r.getAttribute('data-category');
        let flav = r.getAttribute('data-flavor');
        let pr = r.getAttribute('data-price');
        let st = r.getAttribute('data-stock');
        let pcs = r.getAttribute('data-pcs');
        csvContent += name + "," + cat + "," + flav + "," + pr + "," + st + "," + pcs + "\n";
    });
    var encodedUri = encodeURI(csvContent);
    var link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", "internal_stock.csv");
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

function downloadPDF() {
    alert('Backend PDF generation will be initialized. (Make sure Java endpoint handles this). For now, calling server for PDF.');
    window.location.href = '${pageContext.request.contextPath}/admin/products/exportPdf';
}

function showToast(msg, color) {
    var t = document.getElementById('toast');
    t.className = 'fixed bottom-6 right-6 z-[100] text-white px-6 py-3 rounded-2xl shadow-2xl font-semibold text-sm ' + (color || 'bg-green-500');
    t.innerText = msg;
    setTimeout(function() { t.className = 'hidden'; }, 3000);
}

/* ── Render & Filter ────────────────────────────────────────────────────────────── */
function applyFilters() {
    var q       = document.getElementById('searchInput').value.toLowerCase();
    var cat     = document.getElementById('catFilter').value;
    var stock   = document.getElementById('stockFilter').value;
    var sort    = document.getElementById('sortSelect').value;

    var rows = Array.from(document.querySelectorAll('.product-row'));
    var visibleCount = 0;
    var totalCount = rows.length;
    var lowCount = 0;

    rows.forEach(function(r) {
        var pName = r.getAttribute('data-name');
        var pCat = r.getAttribute('data-category');
        var pFlavor = r.getAttribute('data-flavor');
        var pStock = parseInt(r.getAttribute('data-stock'));

        var matchQ   = (pName + ' ' + pFlavor + ' ' + pCat).indexOf(q) !== -1;
        var matchCat = cat === 'all' || pCat === cat;
        var matchSt  = stock === 'all' || (stock === 'low' ? pStock < 50 : pStock >= 50);
        
        if (matchQ && matchCat && matchSt) {
            r.style.display = '';
            visibleCount++;
        } else {
            r.style.display = 'none';
        }
        
        if (pStock < 50) lowCount++;
    });

    document.getElementById('emptyState').classList.toggle('hidden', visibleCount > 0);
    document.getElementById('statTotal').innerText = totalCount;
    document.getElementById('statLow').innerText = lowCount;
    document.getElementById('statShowing').innerText = visibleCount;

    // Sort DOM
    var tbody = document.getElementById('productTableBody');
    rows.sort(function(a, b) {
        var aName = a.getAttribute('data-name');
        var bName = b.getAttribute('data-name');
        var aPrice = parseFloat(a.getAttribute('data-price'));
        var bPrice = parseFloat(b.getAttribute('data-price'));
        var aStock = parseInt(a.getAttribute('data-stock'));
        var bStock = parseInt(b.getAttribute('data-stock'));

        if (sort === 'az')         return aName.localeCompare(bName);
        if (sort === 'za')         return bName.localeCompare(aName);
        if (sort === 'price-asc')  return aPrice - bPrice;
        if (sort === 'price-desc') return bPrice - aPrice;
        if (sort === 'stock-asc')  return aStock - bStock;
        if (sort === 'stock-desc') return bStock - aStock;
        return 0;
    });

    rows.forEach(function(r) {
        tbody.appendChild(r);
    });
}

/* ── View Modal ───────────────────────────────────────────────────────── */
function openViewModal(trElement) {
    document.getElementById('modalTitle').innerText  = 'View Product - ' + trElement.getAttribute('data-name').toUpperCase();
    document.getElementById('f_name').value          = trElement.getAttribute('data-name');
    document.getElementById('f_category').value      = trElement.getAttribute('data-category');
    document.getElementById('f_flavor').value        = trElement.getAttribute('data-flavor');
    document.getElementById('f_price').value         = trElement.getAttribute('data-price');
    document.getElementById('f_stock').value         = trElement.getAttribute('data-stock');
    document.getElementById('f_pcsPerBox').value     = trElement.getAttribute('data-pcs') || '';
    document.getElementById('f_desc').value          = trElement.getAttribute('data-desc') || '';
    document.getElementById('productViewModal').classList.remove('hidden');
}
function closeModal() {
    document.getElementById('productViewModal').classList.add('hidden');
}

/* ── Reset Filters ────────────────────────────────────────────────────── */
function resetFilters() {
    document.getElementById('searchInput').value   = '';
    document.getElementById('catFilter').value     = 'all';
    document.getElementById('stockFilter').value   = 'all';
    document.getElementById('sortSelect').value    = 'az';
    applyFilters();
}

// Close modals on backdrop click
document.getElementById('productViewModal').addEventListener('click', function(e){ if(e.target===this) closeModal(); });

// Initial render
applyFilters();
</script>
</body>
</html>