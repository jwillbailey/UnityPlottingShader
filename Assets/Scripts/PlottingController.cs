using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using PlottingTools;
using System;

public class PlottingController : MonoBehaviour
{
    private Renderer renderer;
    private float[] testSignal;
    [NonSerialized]
    public float[] signal;
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


    public void UpdateSignal(float x)
    {
        signal[signalIndex] = x;
        signalIndex++;
        if (signalIndex >= 1000) signalIndex -= 1000;
    }

    public void UpdateSignal(float[] x)
    {
        for (int i = 0; i < x.Length; i++)
        {
            signal[signalIndex] = x[i];
            signalIndex++;
            if (signalIndex >= 1000) signalIndex -= 1000;
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
                testSignal[i] = Mathf.Sin(((float)i * 6.28f) / 500f + (Time.time));
            }
            renderer.material.SetFloatArray("_data", testSignal);
        }
        else
        {
            renderer.material.SetFloatArray("_data", signal);
        }
    }
}
