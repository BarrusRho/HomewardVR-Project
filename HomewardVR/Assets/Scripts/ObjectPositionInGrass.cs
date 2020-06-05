using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectPositionInGrass : MonoBehaviour
{
    public Transform Object;

    private Renderer _renderer;

    // Start is called before the first frame update
    void Start()
    {
        _renderer = GetComponent<Renderer>();
    }

    // Update is called once per frame
    void Update()
    {
        _renderer.material.SetVector("_ObjectPosition", Object.position);
    }
}
