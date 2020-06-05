using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayAcrossScenes : MonoBehaviour
{ 
    private static PlayAcrossScenes instance = null;

    public static PlayAcrossScenes Instance
    {
        get { return instance; }
    }
        
    void Awake()
    {
        if (instance != null && instance != this)
        {
            Destroy(this.gameObject);
            return;
        }
        else
        {
            instance = this;
        }
        DontDestroyOnLoad(this.gameObject);
    }
}
