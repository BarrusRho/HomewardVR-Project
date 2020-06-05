using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SkullSpawnManager : MonoBehaviour
{
    [SerializeField]
    private GameObject[] spawnedSkull;

    [SerializeField]
    private Transform[] spawnPoints;

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(SkullSpawnRoutine(30.0f));
    }

    // Update is called once per frame
    void Update()
    {

    }

    IEnumerator SkullSpawnRoutine(float delay = 0.0f)
    {
        if (delay != 0)
           {
               yield return new WaitForSeconds(delay);

               while (true)
               {
                    GameObject skull = Instantiate(spawnedSkull[Random.Range(0, 2)], spawnPoints[Random.Range(0, 12)]);

                    skull.transform.localPosition = Vector3.zero;

                    yield return new WaitForSeconds(Random.Range(8f, 16f));
               }                
           }            
        }

    }

