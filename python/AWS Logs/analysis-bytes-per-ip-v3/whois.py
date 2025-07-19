import pandas as pd
import asyncio
import aiohttp
from ipwhois import IPWhois
from ipwhois.exceptions import IPDefinedError

async def fetch_whois(session, ip):
    try:
        obj = IPWhois(ip)
        res = obj.lookup_rdap()
        org = res.get('network', {}).get('name', 'N/A')
        print(f"Getting data for {ip}")
        return {'ip': ip, 'organization': org}
    except IPDefinedError:
        return {'ip': ip, 'organization': 'Reserved/Private IP'}
    except Exception as e:
        return {'ip': ip, 'organization': 'Error: ' + str(e)}

async def fetch_all_whois(ips, max_workers=100):
    tasks = []
    async with aiohttp.ClientSession() as session:
        for ip in ips:
            tasks.append(fetch_whois(session, ip))
        results = await asyncio.gather(*tasks)
    return results

def main(input_file='master-analysis-july.csv', output_file='master-analysis-july-whois.csv', batch_size=1000):
    # Read IP addresses from CSV
    df = pd.read_csv(input_file)
    ips = df['dstaddr'].tolist()

    whois_data = []
    total_ips = len(ips)
    
    for start in range(0, total_ips, batch_size):
        end = start + batch_size
        batch = ips[start:end]
        print(f'Processing batch {start // batch_size + 1} / {(total_ips // batch_size) + 1}')
        
        # Fetch WHOIS data for the current batch
        batch_whois_data = asyncio.run(fetch_all_whois(batch))
        whois_data.extend(batch_whois_data)

    # Convert the results to a DataFrame and save to CSV
    whois_df = pd.DataFrame(whois_data)
    whois_df.to_csv(output_file, index=False)

    print(f"WHOIS data saved to {output_file}")

if __name__ == "__main__":
    main()
