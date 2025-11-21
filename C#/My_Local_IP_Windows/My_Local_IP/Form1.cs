using System.Net.NetworkInformation;
using System.Net.Sockets;
using System.Text;

namespace My_Local_IP
{
    public partial class frmMain : Form
    {
        public frmMain()
        {
            InitializeComponent();
        }

        private void frmMain_Load(object sender, EventArgs e)
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("Hostname: " + Environment.MachineName);
            sb.AppendLine("");

            foreach (NetworkInterface ni in NetworkInterface.GetAllNetworkInterfaces())
            {
                foreach (UnicastIPAddressInformation ip in ni.GetIPProperties().UnicastAddresses)
                {
                    if (ip.Address.AddressFamily == AddressFamily.InterNetwork && !ip.Address.ToString().StartsWith("169.") && ip.Address.ToString() != "127.0.0.1")
                    {
                        sb.AppendLine("Interface: " + ni.Name);
                        sb.AppendLine("IPv4: " + ip.Address.ToString());
                        sb.AppendLine("");
                    }
                }
            }

            txbNetwork.Text = sb.ToString().Trim();
        }

        private void btnCopy_Click(object sender, EventArgs e)
        {
            Clipboard.SetText(txbNetwork.Text);
            MessageBox.Show("Informações copiadas!", "Copiado", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
    }
}
