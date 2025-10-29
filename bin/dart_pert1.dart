import 'package:dart_pert1/dart_pert1.dart' as dart_pert1;
import 'dart:io';

class Item {
  String name;
  double price;
  int quantity;

  Item(this.name, this.price, this.quantity);

  double get totalPrice => price * quantity;
}

class Product {
  String name;
  double price;
  String category;

  Product(this.name, this.price, this.category);
}

class Kasir {
  List<Item> items = [];
  double discountThreshold = 100000;
  double discountRate = 0.1; // 10% discount

  // Daftar produk yang tersedia
  List<Product> availableProducts = [
    // Makanan
    Product('Nasi Goreng', 15000, 'Makanan'),
    Product('Mie Ayam', 12000, 'Makanan'),
    Product('Bakso', 10000, 'Makanan'),
    Product('Gado-gado', 8000, 'Makanan'),
    Product('Soto Ayam', 13000, 'Makanan'),

    // Minuman
    Product('Es Teh', 3000, 'Minuman'),
    Product('Es Jeruk', 5000, 'Minuman'),
    Product('Kopi', 8000, 'Minuman'),
    Product('Jus Alpukat', 12000, 'Minuman'),
    Product('Air Mineral', 2000, 'Minuman'),

    // Snack
    Product('Keripik', 5000, 'Snack'),
    Product('Biskuit', 7000, 'Snack'),
    Product('Coklat', 15000, 'Snack'),
    Product('Permen', 2000, 'Snack'),
    Product('Kacang', 6000, 'Snack'),
  ];

  void displayMenu() {
    print('\n📋 DAFTAR MENU & HARGA');
    print('=' * 60);

    Map<String, List<Product>> groupedProducts = {};

    // Kelompokkan produk berdasarkan kategori
    for (Product product in availableProducts) {
      if (!groupedProducts.containsKey(product.category)) {
        groupedProducts[product.category] = [];
      }
      groupedProducts[product.category]!.add(product);
    }

    int index = 1;
    for (String category in groupedProducts.keys) {
      print('\n🔸 $category:');
      for (Product product in groupedProducts[category]!) {
        print(
          '  $index. ${product.name.padRight(20)} - Rp${product.price.toStringAsFixed(0)}',
        );
        index++;
      }
    }
    print('\n' + '=' * 60);
  }

  void addItemByIndex(int index, int quantity) {
    if (index < 1 || index > availableProducts.length) {
      print('❌ Nomor menu tidak valid');
      return;
    }

    Product selectedProduct = availableProducts[index - 1];
    items.add(Item(selectedProduct.name, selectedProduct.price, quantity));
    print('✓ ${selectedProduct.name} (${quantity}x) berhasil ditambahkan');
  }

  double calculateSubtotal() {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double calculateDiscount(double subtotal) {
    return subtotal >= discountThreshold ? subtotal * discountRate : 0;
  }

  double calculateTotal() {
    double subtotal = calculateSubtotal();
    double discount = calculateDiscount(subtotal);
    return subtotal - discount;
  }

  void printReceipt() {
    print('\n' + '=' * 60);
    print('                    STRUK BELANJA');
    print('=' * 60);

    if (items.isEmpty) {
      print('Tidak ada item yang dibeli.');
      return;
    }

    // Header tabel
    print(
      'Item'.padRight(25) + 'Qty'.padRight(6) + 'Harga'.padRight(12) + 'Total',
    );
    print('-' * 60);

    // Daftar item
    for (Item item in items) {
      String itemName = item.name.length > 23
          ? item.name.substring(0, 23)
          : item.name;
      print(
        itemName.padRight(25) +
            '${item.quantity}x'.padRight(6) +
            'Rp${item.price.toStringAsFixed(0)}'.padRight(12) +
            'Rp${item.totalPrice.toStringAsFixed(0)}',
      );
    }

    print('-' * 60);

    double subtotal = calculateSubtotal();
    double discount = calculateDiscount(subtotal);
    double total = calculateTotal();

    print('Subtotal: '.padRight(45) + 'Rp${subtotal.toStringAsFixed(0)}');

    if (discount > 0) {
      print(
        'Diskon (10%): '.padRight(45) + '-Rp${discount.toStringAsFixed(0)}',
      );
    }

    print('=' * 60);
    print('TOTAL: '.padRight(45) + 'Rp${total.toStringAsFixed(0)}');
    print('=' * 60);

    if (discount > 0) {
      print('🎉 Selamat! Anda mendapat diskon 10%');
      print('💰 Hemat: Rp${discount.toStringAsFixed(0)}');
    }
  }

  void clearItems() {
    items.clear();
  }
}

void main(List<String> arguments) {
  Kasir kasir = Kasir();

  print('🛒 SISTEM KASIR WARUNG MAKAN');
  print('=' * 40);

  while (true) {
    print('\nMenu Utama:');
    print('1. Lihat daftar menu');
    print('2. Tambah item ke keranjang');
    print('3. Lihat keranjang belanja');
    print('4. Checkout & keluar');
    print('5. Reset keranjang');
    stdout.write('Pilih menu (1-5): ');

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        kasir.displayMenu();
        break;
      case '2':
        addItemFlow(kasir);
        break;
      case '3':
        kasir.printReceipt();
        break;
      case '4':
        print('\n🧾 STRUK PEMBELIAN AKHIR:');
        kasir.printReceipt();
        print('\nTerima kasih telah berbelanja! 🙏');
        print('Sampai jumpa lagi! 😊');
        return;
      case '5':
        kasir.clearItems();
        print('✓ Keranjang belanja telah dikosongkan');
        break;
      default:
        print('❌ Pilihan tidak valid');
    }
  }
}

void addItemFlow(Kasir kasir) {
  try {
    kasir.displayMenu();

    stdout.write('\nPilih nomor menu (1-${kasir.availableProducts.length}): ');
    String? menuChoice = stdin.readLineSync();
    int menuIndex = int.parse(menuChoice ?? '0');

    if (menuIndex < 1 || menuIndex > kasir.availableProducts.length) {
      print('❌ Nomor menu tidak valid');
      return;
    }

    Product selectedProduct = kasir.availableProducts[menuIndex - 1];
    print(
      '📦 Dipilih: ${selectedProduct.name} - Rp${selectedProduct.price.toStringAsFixed(0)}',
    );

    stdout.write('Jumlah yang ingin dibeli: ');
    String? quantityInput = stdin.readLineSync();
    int quantity = int.parse(quantityInput ?? '1');

    if (quantity <= 0) {
      print('❌ Jumlah harus lebih dari 0');
      return;
    }

    kasir.addItemByIndex(menuIndex, quantity);

    double itemTotal = selectedProduct.price * quantity;
    print('💰 Total untuk item ini: Rp${itemTotal.toStringAsFixed(0)}');
  } catch (e) {
    print('❌ Input tidak valid. Pastikan memasukkan angka yang benar.');
  }
}
