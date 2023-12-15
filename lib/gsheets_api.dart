import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  //Create credtials for gsheet api
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "pennywoth-gsheet",
  "private_key_id": "c70a06be98cabd8655a0f19005fa3ce8dcc68117",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCsjOZL/eD6g60X\nSM+ozaqIEqxCqimpqvGsJ+/KeWdOkep2BQozDmcvVKf2CHDmfM9Fde32h6zgPawC\nQ3RmlfH4KtTRXedcANYjMfcHlkHOKJ3Zp4dNt8UNgSmPIYsGuVbTv+6iQ6lss5o8\n+wtS6UsXWJCydwyZOf8kSeKSgHBhmqF1jw3/SG82zxzZ7u+lT+wQ/pKh7SiD3jaz\ny563C0WFMpWiTpbna0OxHiBuV3CEKubrjNfmY2dA8whLM0IYQE+f5hjNJ2NczyhD\nZJGvKr3/3jBDTHXt4MIvtIT/cq9ZGJBK89yLiMdzdESnZmrVTyqL4JTYZkDLDIyz\nCzAgaamlAgMBAAECggEABUnR2r0y+1BjAaZGfqssdFOi6L88oeyiz/60zh3GJnW5\nOQHyztmCec/t0ERZJL9GbPzihYFEX/3Cb4OBd43KSdoqNG86BYhXZOJ6AcccjpB5\n19gdAOVGePLNmmiMLnzksaz6vDggkYGg8B/K2zEUbFFAKVL+puZMvIMIGof+Y/AX\n5z7uKIgRvnMeinb4V93c8cuhRxFnjeTBVRGMRJQH9rTn+gByk16Le0Tf5pFL/aje\niL1DthuI5lDPhzm5NNkyXxGZ18a9wn1j0MvjTiUYheDXwyQkXbNYaL7MGH50d0sp\nD0pqIlIZzjmEHJjNjV7qdGYIPvMbjlzHl58SEjGIqwKBgQDdVG60q8fLByEzYkiU\n/W5jzDJMdFOTdOisLOK1m1tfs+FqD2R2HbGm6xUEi2Yz3uwa/vbz3/5AGmyc0Qpi\nhSrXemL+I2IENMrye7Q8Jw/1Rrho5bK/Mtsw4HXhNDcr+U2jTxE++w3b3BlPZ03l\nPNaUiiNSKK1gZQLb2CySFWd0GwKBgQDHlFvesVef3K3HqhQ+IJHSvpqmqdZPNJZ0\ntuqv0c1FKw3wVmtGIzXYcfDn9PsMkRFUSlLT+H6ejVFVI7EMM+aXRlucZYJp+ktH\nMDVtjWIi1115mTPWdo7/5dgW+sn7MzVv0ffbhc1ZPXLdWCwJsIjgM7hBCaKrjNbQ\naAIhAGe1PwKBgQCd9QgdQQuRxkDXnykVy9jguHadQdfzwNfdKRuTaJDJuGMDgoC8\nG20SJ2wUljgWhN4UViqA2jdmIHWrZTT4Ivn0VpAXt8DYJ6U/cTGsTGSDNDmgA26S\nLgVo2IjIdK97Xq0eA+vW+u1lH6ugk6VwGP87e2rB0+4IgY6Mv7bvev8eSQKBgCMN\nJU1pLBCBe2vTrRZ0NegjXZnjviXPAJWjAni6iiiZtSr+onyA9pX6/OpgFi9Q0xBQ\ntVdRDzvdaelgCVoxS1BKJRDEqzDdqpboGpoQ+KlR1bLjez0xOVAsF9WBWjPp/HqV\nD8jYKQaBSkkhkSpqfL+TlcqmXJFwfNHBUo5lOdGVAoGAUxic+YmRy3Iy+2Yv6ror\nHxecWOqQbUYjJ3HLjl2ndajjlMIOM0nGf4ICqQmSFQ0lDIMjQUnO4eLnHlYffMwh\nKA8MO5LpfLLAO0DLWUVbNuvjDJA+uTh9t6aeZ0dsMPEDvorJmhYi4KHG+Yx5ukxy\nwl1/Yz8U9NM4xjUpXY0XVog=\n-----END PRIVATE KEY-----\n",
  "client_email": "pennywoth-gsheet@pennywoth-gsheet.iam.gserviceaccount.com",
  "client_id": "112549723413127034761",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/pennywoth-gsheet%40pennywoth-gsheet.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';

// spreadsheet id
  static final _spreadsheetId = '1WvT7q6gwVUsi4LIQmrIvV3IAlpsMP9uMwoTpb_3fknQ';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  //varibles
  static int numOfTrans = 0;
  static List<List<dynamic>> currentTrans = [];
  static bool loading = true;

  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  static Future countRows() async {
    while ((await _worksheet!.values.value(column: 1, row: numOfTrans + 1)) !=
        '') {
      numOfTrans++;
    }
    loadTransactions();
  }

  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numOfTrans; i++) {
      final String transName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String amount =
          await _worksheet!.values.value(column: 2, row: i + 1);

      if (currentTrans.length < numOfTrans) {
        currentTrans.add([transName, amount]);
      }
    }

    loading = false;
  }
}
