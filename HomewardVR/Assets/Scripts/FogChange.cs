using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FogChange : MonoBehaviour
{
    [SerializeField]
    private Color _newFogColor;

    // Start is called before the first frame update
    void Start()
    {
        RenderSettings.fogColor = RenderSettings.fogColor;

        //RenderSettings.fog = true;

        
    }

    // Update is called once per frame
    void Update()
    {
        Color colorA = _newFogColor;

        RenderSettings.fogColor  = Color.Lerp(RenderSettings.fogColor, colorA, Time.deltaTime * 0.2f);
    }
}
