package tools.zxing.client.result
{
	/*
 * Copyright 2007 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import tools.zxing.Result;

/**
 * @author Sean Owen
 */
public final class BookmarkDoCoMoResultParser extends AbstractDoCoMoResultParser 
{

  public function BookmarkDoCoMoResultParser() 
  {
  }

  public static function parse(result:Result):URIParsedResult {
    var rawText:String = result.getText();
    if (rawText == null || (rawText.substr(0,6) != "MEBKM:")) {
      return null;
    }
    var title:String = matchSingleDoCoMoPrefixedField("TITLE:", rawText, true);
    var rawUri:Array = matchDoCoMoPrefixedField("URL:", rawText, true);
    if (rawUri == null) {
      return null;
    }
    var uri:String = rawUri[0];
    if (!URIResultParser.isBasicallyValidURI(uri)) {
      return null;
    }
    return new URIParsedResult(uri, title);
  }

}
}