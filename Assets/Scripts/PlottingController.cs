using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using PlottingTools;
using System;

public class PlottingController : MonoBehaviour
{
    private Renderer renderer;
    private float[] testSignal;
    public float testSignalFrequency = 10f;
    public float testSignalSpeed = 1f;
    [NonSerialized]
    public float[] signal_0;
    [NonSerialized] 
    public float[] signal_1;
    [NonSerialized] 
    public float[] signal_2;

    private int signalIndex;
    public bool useTestSignal;

    public void ResetSignalIndex()
    {
        signalIndex = 0;
    }

    public void SetSignalIndex(int x)
    {
        signalIndex = x;
        if (signalIndex >= 1000) signalIndex -= 1000;
    }

    public void IncrementSignalIndex(int x)
    {
        signalIndex++;
        if (signalIndex >= 1000) signalIndex -= 1000;
    }

    public void DecrementSignalIndex(int x)
    {
        signalIndex--;
        if (signalIndex <= 0) signalIndex += 1000;
    }

    public void UpdateSignal(float x, int channel)
    {
        switch (channel)
        {
            case 0:
                signal_0[signalIndex] = x;
                break;

            case 1:
                signal_1[signalIndex] = x;
                break;

            case 2:
                signal_2[signalIndex] = x;
                break;
            default:
                signal_0[signalIndex] = x;
                break;

        }
    }

    public void UpdateSignal(float[] x, int channel)
    {
        switch (channel)
        {
            case 0:
                for (int i = 0; i < x.Length; i++)
                {
                    signal_0[signalIndex] = x[i];
                    
                }
                break;

            case 1:
                for (int i = 0; i < x.Length; i++)
                {
                    signal_1[signalIndex] = x[i];
                    
                }
                break;

            case 2:
                for (int i = 0; i < x.Length; i++)
                {
                    signal_2[signalIndex] = x[i];
                    
                }
                break;
            default:
                for (int i = 0; i < x.Length; i++)
                {
                    signal_0[signalIndex] = x[i];
                    
                }
                break;

        }
        
    }

    // Start is called before the first frame update
    void Start()
    {
        signalIndex = 0;
        renderer = GetComponent<Renderer>();
        testSignal = new float[1000];
        for(int i = 0; i<1000; i++)
        {
            testSignal[i] = Mathf.Sin(((float)i * 6.28f) / 500f);
        }

    }

    // Update is called once per frame
    void Update()
    {
        if (useTestSignal)
        {
            for (int i = 0; i < 1000; i++)
            {
                testSignal[i] = Mathf.Sin(((float)i * 6.28f*testSignalFrequency) + (Time.time*testSignalSpeed));
            }
            renderer.material.SetFloatArray("_data_ch1", testSignal);
            renderer.material.SetFloatArray("_data_ch2", testSignal);
            renderer.material.SetFloatArray("_data_ch3", testSignal);
        }
        else
        {
            renderer.material.SetFloatArray("_data_ch1", signal_0);
            renderer.material.SetFloatArray("_data_ch2", signal_1);
            renderer.material.SetFloatArray("_data_ch3", signal_2);
        }
    }
}
