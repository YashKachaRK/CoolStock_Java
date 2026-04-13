<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tax Invoice | ${order.orderNumber}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
        @media print {
            .no-print { display: none !important; }
            body { background: white; }
            .print-shadow { box-shadow: none !important; border: 1px solid #eee; }
        }
    </style>
    <!-- jsPDF and html2canvas Libraries -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
</head>
<body class="bg-gray-100 p-8">

    <div id="invoice-card" class="max-w-4xl mx-auto bg-white p-12 rounded-[2rem] shadow-2xl print-shadow relative overflow-hidden">
        
        <!-- Header Section -->
        <div class="flex justify-between items-start mb-12">
            <div>
                <h1 class="text-4xl font-black text-gray-900 tracking-tighter">🍦 COOLSTOCK</h1>
                <p class="text-xs text-gray-400 font-bold uppercase tracking-[0.3em] mt-1">Enterprise Inventory Solutions</p>
                <div class="mt-6 text-sm text-gray-500 leading-relaxed font-medium">
                    Corporate Office: 123 Ice Cream Tower,<br>
                    Industrial Hub, Gujarat 380001<br>
                    GSTIN: 24COOLSTOCK99Z1
                </div>
            </div>
            <div class="text-right">
                <h2 class="text-2xl font-black text-emerald-600 tracking-tighter">TAX INVOICE</h2>
                <div class="mt-4 space-y-1">
                    <p class="text-xs font-black text-gray-400 uppercase tracking-widest">Invoice Number</p>
                    <p class="text-xl font-bold text-gray-900">${order.orderNumber}</p>
                    <p class="text-xs font-black text-gray-400 uppercase tracking-widest mt-4">Order Date</p>
                    <p class="text-sm font-bold text-gray-700">
                        <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, hh:mm a" />
                    </p>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-2 gap-12 mb-12 py-8 border-y border-gray-100">
            <div>
                <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-3">BILL TO (RECIPIENT)</p>
                <h3 class="text-xl font-black text-gray-900">${order.customer.shopName}</h3>
                <p class="text-sm text-gray-500 font-medium mt-1 uppercase italic">${order.customer.ownerName}</p>
                <p class="text-sm text-gray-500 mt-2 leading-relaxed">
                    ${order.customer.area}, ${order.customer.city}<br>
                    Phone: ${order.customer.phone}<br>
                    Email: ${order.customer.email}
                </p>
            </div>
            <div class="text-right">
                <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-3">PAYMENT DETAILS</p>
                <div class="inline-block bg-gray-50 px-6 py-4 rounded-2xl border border-gray-100">
                    <p class="text-xs font-bold text-gray-400">Transaction Status</p>
                    <p class="text-lg font-black ${order.paymentStatus == 'Paid' ? 'text-emerald-600' : 'text-orange-600'} uppercase">
                        ${order.paymentStatus}
                    </p>
                    <p class="text-[10px] font-black text-gray-300 mt-1 uppercase tracking-widest">COD / BANK DEPOSIT</p>
                </div>
            </div>
        </div>

        <!-- Items Table -->
        <table class="w-full text-left mb-12">
            <thead>
                <tr class="bg-gray-900 text-white">
                    <th class="py-4 px-6 rounded-l-2xl text-[10px] font-black uppercase tracking-widest">Item Description</th>
                    <th class="py-4 px-6 text-center text-[10px] font-black uppercase tracking-widest">Quantity</th>
                    <th class="py-4 px-6 text-right text-[10px] font-black uppercase tracking-widest">Unit Price</th>
                    <th class="py-4 px-6 text-right rounded-r-2xl text-[10px] font-black uppercase tracking-widest">Total Price</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-50">
                <c:forEach var="item" items="${order.items}">
                    <tr>
                        <td class="py-6 px-6">
                            <p class="font-black text-gray-900 uppercase text-sm">${item.product.name}</p>
                            <p class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mt-0.5">${item.product.productCode}</p>
                        </td>
                        <td class="py-6 px-6 text-center font-black text-gray-600">${item.quantity} BOX</td>
                        <td class="py-6 px-6 text-right font-mono text-gray-500 italic font-bold">₹${item.unitPrice}</td>
                        <td class="py-6 px-6 text-right font-black text-gray-900 font-mono tracking-tighter">₹${item.totalPrice}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- Summary -->
        <div class="flex justify-end pr-6">
            <div class="w-full max-w-xs space-y-4">
                <div class="flex justify-between text-sm text-gray-500 font-bold italic">
                    <p>Subtotal</p>
                    <p>₹${order.totalAmount}</p>
                </div>
                <div class="flex justify-between text-sm text-gray-500 font-bold italic">
                    <p>GST (Included)</p>
                    <p>₹0.00</p>
                </div>
                <div class="flex justify-between py-6 px-8 bg-gray-900 rounded-[1.5rem] shadow-xl text-white">
                    <p class="text-xs font-black uppercase tracking-widest self-center opacity-60">Grand Total</p>
                    <p class="text-3xl font-black font-mono tracking-tight">₹${order.totalAmount}</p>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <div class="mt-20 pt-12 border-t border-gray-100 flex justify-between items-center opacity-50 italic">
            <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">This is a computer generated document. No signature required.</p>
            <p class="text-[10px] font-black text-gray-800 uppercase tracking-tighter">CoolStock Enterprise Logistics Systems v2.0</p>
        </div>

    </div>

    <!-- Download FAB - No Print Option -->
    <div class="fixed bottom-10 right-10 flex flex-col gap-4">
        <button onclick="downloadPDF()" 
                class="bg-blue-600 text-white w-20 h-20 rounded-full flex items-center justify-center shadow-2xl hover:bg-blue-700 transition scale-110 group">
            <span class="text-2xl group-hover:scale-125 transition">📥</span>
        </button>
    </div>

    <script>
        window.jsPDF = window.jspdf.jsPDF;

        function downloadPDF() {
            const element = document.getElementById('invoice-card');
            
            html2canvas(element, { scale: 3, useCORS: true }).then(canvas => {
                const imgData = canvas.toDataURL('image/png');
                const pdf = new jsPDF('p', 'mm', 'a4');
                
                const imgProps = pdf.getImageProperties(imgData);
                const pdfWidth = pdf.internal.pageSize.getWidth();
                const pdfHeight = (imgProps.height * pdfWidth) / imgProps.width;
                
                pdf.addImage(imgData, 'PNG', 0, 0, pdfWidth, pdfHeight);
                pdf.save('Invoice_${order.orderNumber}.pdf');
            });
        }
    </script>
</body>
</html>
