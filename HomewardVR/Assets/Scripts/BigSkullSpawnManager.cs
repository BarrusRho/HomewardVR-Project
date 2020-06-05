using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BigSkullSpawnManager : MonoBehaviour
{
    [SerializeField]
    private GameObject _firstBigSkull;

    [SerializeField]
    private GameObject _secondBigSkull;

    // Start is called before the first frame update
    void Start()
    {
        _firstBigSkull.SetActive(true);        

        Invoke("ActivateSecondBigSkull", 7.0f);
    }
    
    void ActivateSecondBigSkull ()
    {
        _secondBigSkull.SetActive(true);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            Destroy(this.gameObject, 0f);
        }
    }
}
