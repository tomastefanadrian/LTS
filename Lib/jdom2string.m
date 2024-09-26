function text=jdom2string(element)


import org.jdom.*;
import org.jdom.output.XMLOutputter;
import org.jdom.output.Format;

serializer =XMLOutputter();
format=serializer.getFormat();
new_format=format.getPrettyFormat();
serializer.setFormat(new_format);
text = serializer.outputString(element);