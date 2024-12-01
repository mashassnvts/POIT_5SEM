using System;
using System.Collections.Generic;
using System.Threading;

class Program
{
    private static readonly object lockObject = new object(); 

    static void Main(string[] args)
    {
        List<Big> bigObjects = new List<Big>();

        Thread fillerThread = new Thread(() =>
        {
            Random random = new Random();
            while (true)
            {
                lock (lockObject)
                {
                    foreach (var big in bigObjects)
                    {
                        FillMemory(big, random);
                    }
                }
                Thread.Sleep(1000); 
            }
        });

        fillerThread.IsBackground = true; 
        fillerThread.Start();

        while (true)
        {
            lock (lockObject)
            {
                bigObjects.Add(new Big());
            }

            long memoryUsed = GC.GetTotalMemory(false) / (1024 * 1024);

            Console.WriteLine($"Используемая память: {memoryUsed} MB");

            Thread.Sleep(5000);
        }
    }

    static void FillMemory(Big big, Random random)
    {
        for (int i = 0; i < big.Data.Length; i++)
        {
            big.Data[i] = (byte)random.Next(0, 256); 
        }
    }
}

class Big
{
    public byte[] Data;

    public Big()
    {
        Data = new byte[128 * 1024 * 1024]; 
    }
}
