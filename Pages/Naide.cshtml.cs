using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Xml.Xsl;

namespace XML_Reis.Pages
{
    public class NaideModel : PageModel
    {
        public string TransformedXml { get; private set; } = "";
        private readonly IWebHostEnvironment _hostingEnvironment;

        public NaideModel(IWebHostEnvironment hostingEnvironment)
        {
            _hostingEnvironment = hostingEnvironment;
        }

        public void OnGet()
        {
            try
            {
                var xmlPath = Path.Combine(_hostingEnvironment.ContentRootPath, "wwwroot", "AnastasiiaSugupuu.xml");
                var xsltPath = Path.Combine(_hostingEnvironment.ContentRootPath, "wwwroot", "Paringud2.xslt");

                if (!System.IO.File.Exists(xmlPath) || !System.IO.File.Exists(xsltPath))
                {
                    TransformedXml = "<p style='color:red'>Error: XML or XSLT file not found.</p>";
                    return;
                }

                var xslt = new XslCompiledTransform();
                xslt.Load(xsltPath);

                using (var sw = new StringWriter())
                {
                    xslt.Transform(xmlPath, null, sw);
                    TransformedXml = sw.ToString();
                }
            }
            catch (Exception ex)
            {
                TransformedXml = $"<p style='color:red'>An error occurred during XML transformation: {ex.Message}</p>";
            }
        }
    }
}
