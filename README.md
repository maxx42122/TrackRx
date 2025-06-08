# TrackRx

TrackRx is a real-time drug inventory and supply chain tracking system built using Flutter. It provides a secure and efficient way to manage medicine distribution from manufacturers to hospitals, ensuring transparency, preventing fraud, and maintaining real-time data integrity.

---

## 🚀 Features

- 📦 Real-time drug tracking using barcode scanning
- ✅ Dual-scan verification for secure delivery (Manufacturer → Inventory → Hospital)
- 🔄 Automatic inventory updates after each transaction
- 💸 Drug billing based on patient ID for transparency
- 📊 Real-time analytics and dashboards
- 📱 Responsive UI for both Web and Mobile (Flutter)
- 🛠️ API tested with Postman, designed in Figma

---

## 🔄 Project Flow

1. **Manufacturer Scan**:  
   When a big box (containing 10 smaller boxes) is prepared, the manufacturer scans the barcode and sends data to the procurement officer.

2. **Inventory Verification**:  
   Upon arrival at inventory, the officer scans the same barcode. The system matches it with the manufacturer data. If matched → marked as successful.

3. **Hospital Delivery**:  
   When a hospital requests medicines, the small boxes inside the big box are scanned again. The hospital officer scans them for final verification.

4. **Inventory Update**:  
   - After successful scanning, the system:
     - Deducts the quantity from inventory
     - Adds it to the hospital stock
     - Updates procurement officer's dashboard

5. **Billing & Analytics**:  
   - Bills are generated based on patient IDs  
   - All bills and movements are visible to hospitals, inventory teams, and procurement officers  
   - Dashboard displays real-time consumption and stock patterns

---

## 📌 Tech Stack

- **Flutter** (Web + Mobile Responsive UI)
- **Figma** (UI/UX Design)
- **Postman** (API Testing)
- **Real-Time API Integration**
- **Firebase / Node.js / MongoDB** *(assumed backend stack if needed)*

---

## 📷 Screenshots

![WhatsApp Image 2025-06-08 at 7 23 02 PM](https://github.com/user-attachments/assets/966e80e7-d3c6-4a51-96cf-3329475fa8ea)
![WhatsApp Image 2025-06-08 at 7 23 02 PM (1)](https://github.com/user-attachments/assets/bc023d55-7ac8-4dca-90ad-0bb77f9abc9b)
![WhatsApp Image 2025-06-08 at 7 23 03 PM (1)](https://github.com/user-attachments/assets/9be778eb-1c34-4aea-84bf-8e5886f23451)
![WhatsApp Image 2025-06-08 at 7 23 03 PM](https://github.com/user-attachments/assets/d0ecca49-0e04-47ad-9607-5eb03bdc96af)
![WhatsApp Image 2025-06-08 at 7 23 03 PM (2)](https://github.com/user-attachments/assets/e9a5abb3-7436-47b4-9bee-8ff86e2afb04)
![WhatsApp Image 2025-06-08 at 7 23 03 PM (3)](https://github.com/user-attachments/assets/87ed5da1-8eca-45e6-b878-596f2079ed93)
![WhatsApp Image 2025-06-08 at 7 23 04 PM](https://github.com/user-attachments/assets/3de5541d-9132-4471-98c7-04614df6f365)
![WhatsApp Image 2025-06-08 at 7 23 05 PM](https://github.com/user-attachments/assets/f589d65b-71b9-4a27-89ca-493064ae4b50)
![WhatsApp Image 2025-06-08 at 7 23 05 PM (3)](https://github.com/user-attachments/assets/aba5adcf-e061-48a2-92db-fdf31cc68561)
![WhatsApp Image 2025-06-08 at 7 23 05 PM (2)](https://github.com/user-attachments/assets/b0328670-26bb-4027-8d3b-8f936d2935b7)
![WhatsApp Image 2025-06-08 at 7 23 05 PM (1)](https://github.com/user-attachments/assets/13d6d523-02c2-412f-a490-99b08d427ed2)

---

## 👨‍💻 Developed By

> Mayur Pawale and Team

---


## 📬 Contact

For inquiries or collaboration, reach out via GitHub or email.
Email-: mayurpawale4212@gmail.com
mobile no-:9325834312
