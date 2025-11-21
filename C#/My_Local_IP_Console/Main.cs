using System.Net.NetworkInformation;
using System.Net.Sockets;
using System.Text;

StringBuilder sb = new StringBuilder();
sb.AppendLine("Hostname: " + Environment.MachineName);
sb.AppendLine("");

foreach (NetworkInterface ni in NetworkInterface.GetAllNetworkInterfaces())
{
    foreach (UnicastIPAddressInformation ip in ni.GetIPProperties().UnicastAddresses)
    {
        if (ip.Address.AddressFamily == AddressFamily.InterNetwork && 
            !ip.Address.ToString().StartsWith("169.") && 
            ip.Address.ToString() != "127.0.0.1")
        {
            sb.AppendLine("Interface: " + ni.Name);
            sb.AppendLine("IPv4: " + ip.Address.ToString());
            sb.AppendLine("");
        }
    }
}

Console.WriteLine(sb.ToString().Trim());

Console.WriteLine("\n\nInformações exibidas! \nPressione qualquer tecla para sair.");
Console.ReadKey();