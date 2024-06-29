import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:warranty_tracker/modal/product_modal.dart';

class GeminiRepository {
  final Gemini gemini = Gemini.instance;
  List<Uint8List>? billImage;

  Future<ProductModal> getDataFromImage(File? file) async {
    String? productName;
    String? purchasedDate;
    int? warrantyPeriod;

    try {
      if (file != null && file.path.isNotEmpty) {
        billImage = [await File(file.path).readAsBytes()];
        final outputBuffer = StringBuffer();

        await for (final event in gemini.streamGenerateContent(
          'Check this image is a product bill/receipt. If this is a product bill/receipt then please tell the product name       /Item name, purchase date/invoice date/order date and warranty period from this product/item bill. Return me result in the json format as "productName", "purchasedDate", "warrantyPeriod". If any thing is empty or not available then pass it as empty string. And also convert purchase date into dd MMM YYY format. For example if date is coming as 26.6.23 convert it to 26 Jun 2023 or if date is 10-12-24 then give 10 Dec 2024 or if date is 5/04/24 then give 5 Apr 2024 or if invoice date is 12-04-2024 then give 12 Apr 2024, For converting months value to months name you can use this { "1": "Jan", "2": "Feb", "3": "Mar", "4": "Apr","5": "May","6": "Jun","7": "Jul","8": "Aug","9": "Sep","10": "Oct","11": "Nov","12": "Dec"} and for the warrantyPeriod I want output in number of months that is integer only. For Example if warranty period is 1 year than give 12 as output if warranty is 6 months then give 6 as warrantyPeriod output. And if you are not getting any warranty period details then give warranty period as 12 by default and if the given image is not a product bill/receipt then give a empty json as output',
          images: billImage,
        )) {
          outputBuffer.write(event.output);
        }

        final result = outputBuffer.toString().trim();
        //print('result: $result');
        final jsonStartIndex = result.indexOf('{');

        final jsonEndIndex = result.lastIndexOf('}') + 1;

        if (jsonStartIndex != -1 && jsonEndIndex != -1) {
          final jsonString = result.substring(jsonStartIndex, jsonEndIndex);
          final parsedResult = parseResult(jsonString);
          //print('parsedResult: $parsedResult');
          productName = parsedResult['productName'] as String?;
          purchasedDate = parsedResult['purchasedDate'] as String?;
          warrantyPeriod = parsedResult['warrantyPeriod'] as int? ?? 12;
        }

        return ProductModal().copyWith(
          productName: productName,
          purchasedDate: purchasedDate,
          warrantyPeriods: warrantyPeriod.toString(),
        );
      } else {
        return ProductModal();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Map<String, dynamic> parseResult(String result) {
    try {
      return jsonDecode(result) as Map<String, dynamic>;
    } catch (e) {
      throw Exception(e);
      // print('Error parsing JSON: $e');
    }
  }
}
